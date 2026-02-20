# Shiny JSON Logic - Performance Refactors

*Fecha: 20 febrero 2026*
*Objetivo: Superar a json_logic (bhgames) en velocidad manteniendo 99.7% compatibilidad*

## Estado actual

| Métrica | shiny_json_logic | json_logic (bhgames) | Factor |
|---------|------------------|----------------------|--------|
| Ruby 4.0 | 328,372 ops/s | 3,018,458 ops/s | **9.2x más lento** |
| Ruby 3.2 | 279,649 ops/s | 2,402,765 ops/s | **8.6x más lento** |
| Archivos .rb | 57 | 6 | 9.5x más |
| Compatibilidad | 99.7% | 63.9% | Nosotros ganamos |

**Meta**: Alcanzar o superar 3M ops/s en Ruby 4.0 sin romper tests.

---

## Análisis de bottlenecks

### 1. Instanciación de objetos por operación (CRÍTICO)

**Código actual** (`engine.rb:18`):
```ruby
operations.fetch(operation_key).new(args, scope_stack).call
```

Cada operación crea una nueva instancia de clase. Para `{"==":[1,1]}`:
- `Engine.new(...)` - 1 instancia
- `Operations::Equal.new(...)` - 1 instancia
- Total: 2 instancias por operación simple

**bhgames hace**:
```ruby
LAMBDAS[operator.to_s].call(interpolated, data)
```
Solo una llamada a lambda, sin instanciación.

**Estimación de impacto**: 40-60% del overhead

---

### 2. OperatorSolver.new en cada operación

**Código actual** (`engine.rb:31` y `base.rb:56`):
```ruby
def operations
  @operations ||= OperatorSolver.new.solvers
end

# En base.rb:
OperatorSolver.new.operation?(value)
```

Aunque `solvers` usa `@@solvers`, se crea un objeto `OperatorSolver` cada vez.

**Estimación de impacto**: 5-10%

---

### 3. IndifferentHash wrapping repetitivo

**Código actual** (`scope_stack.rb:85-92`):
```ruby
def wrap_indifferent(obj)
  if obj.is_a?(IndifferentHash)
    obj
  elsif obj.is_a?(Hash)
    IndifferentHash.new(obj)
  else
    obj
  end
end
```

Se llama en:
- `ScopeStack.new` (1x)
- `ScopeStack#push` (Nx para iteradores)
- `dig_value` para nested hashes

`SimpleDelegator` tiene overhead. Cada wrap crea un objeto nuevo.

**Estimación de impacto**: 10-15%

---

### 4. validate_operators! traversal completo

**Código actual** (`shiny_json_logic.rb:20-42`):
```ruby
def self.apply(rule, data = {})
  validate_operators!(rule)  # Traversa TODO el árbol ANTES de ejecutar
  # ...
end
```

Se recorre el árbol dos veces:
1. `validate_operators!` - validación
2. `engine.call` - ejecución

**bhgames no valida**, simplemente falla si el operador no existe.

**Estimación de impacto**: 15-25% (dependiendo de profundidad del árbol)

---

### 5. String splitting en var

**Código actual** (`var.rb:26`):
```ruby
keys = key.to_s.split('.')
```

Para cada `{"var": "user.name"}` se crea un array nuevo con strings.

**Estimación de impacto**: 2-5%

---

### 6. numeric_string? usa excepciones para control de flujo

**Código actual** (`numerify.rb:17-22`):
```ruby
def numeric_string?(value)
  Float(value)
  true
rescue ArgumentError
  false
end
```

Excepciones son caras. Se llama en cada comparación numérica.

**Estimación de impacto**: 3-8% (depende de datos)

---

### 7. Engine.new recursivo en evaluate

**Código actual** (`base.rb:29-31`):
```ruby
def evaluate(rule)
  Engine.new(rule, scope_stack).call
end
```

Cada sub-expresión crea un nuevo Engine.

**Estimación de impacto**: 10-15%

---

## Refactors propuestos

### Fase 1: Quick wins (sin cambio de arquitectura)

#### 1.1 Singleton para OperatorSolver

**Antes**:
```ruby
def operations
  @operations ||= OperatorSolver.new.solvers
end
```

**Después**:
```ruby
SOLVERS = OperatorSolver.solvers.freeze

def operations
  SOLVERS
end
```

**Impacto estimado**: +5-10%
**Riesgo**: Bajo
**Esfuerzo**: 1 hora

---

#### 1.2 Eliminar validate_operators! (modo lazy)

**Opción A**: Eliminar completamente (como bhgames)
```ruby
def self.apply(rule, data = {})
  # Sin validación
  scope_stack = ScopeStack.new(data || {})
  Engine.new(rule, scope_stack).call
end
```

**Opción B**: Validación opcional
```ruby
def self.apply(rule, data = {}, validate: false)
  validate_operators!(rule) if validate
  # ...
end
```

**Impacto estimado**: +15-25%
**Riesgo**: Medio (errores menos descriptivos)
**Esfuerzo**: 30 minutos

---

#### 1.3 Regex para numeric_string?

**Antes**:
```ruby
def numeric_string?(value)
  Float(value)
  true
rescue ArgumentError
  false
end
```

**Después**:
```ruby
NUMERIC_REGEX = /\A-?\d+(\.\d+)?(e[+-]?\d+)?\z/i.freeze

def numeric_string?(value)
  NUMERIC_REGEX.match?(value)
end
```

**Impacto estimado**: +3-5%
**Riesgo**: Bajo (puede haber edge cases)
**Esfuerzo**: 1 hora (incluyendo tests)

---

#### 1.4 Frozen strings everywhere

Añadir a todos los archivos:
```ruby
# frozen_string_literal: true
```

Y usar `.freeze` en constantes string:
```ruby
EMPTY_STRING = "".freeze
```

**Impacto estimado**: +2-5%
**Riesgo**: Bajo
**Esfuerzo**: 2 horas

---

### Fase 2: Refactors medianos

#### 2.1 Convertir operaciones a métodos estáticos (RECOMENDADO)

**Análisis**: Este refactor elimina la instanciación de objetos por operación, que es el bottleneck más grande (40-60% del overhead).

**Arquitectura actual**:
```ruby
# engine.rb
operations.fetch(operation_key).new(args, scope_stack).call

# operations/addition.rb
class Addition < Base
  include Numerify
  include WithErrorHandling

  def call
    @rules.reduce(0) { |sum, rule| sum + numerify(evaluate(rule)) }
  end
end
```

**Arquitectura propuesta**:
```ruby
# engine.rb
operations.fetch(operation_key).call(args, scope_stack)

# operations/addition.rb
class Addition < Base
  extend Numerify
  extend WithErrorHandling

  def self.call(rules, scope_stack)
    rules.reduce(0) { |sum, rule| sum + numerify(evaluate(rule, scope_stack)) }
  end
end
```

**Cambios necesarios por archivo**:

| Archivo | Cambios |
|---------|---------|
| `engine.rb` | Cambiar `.new(args, scope_stack).call` → `.call(args, scope_stack)` |
| `operations/base.rb` | Convertir `initialize` + `call` a `def self.call(rules, scope_stack)` |
| `operations/*.rb` (simples) | Cambiar `def call` → `def self.call(rules, scope_stack)`, `@rules` → `rules` |
| Mixins (`numerify.rb`, `with_error_handling.rb`) | Cambiar `include` → `extend` o hacer métodos de módulo |
| `operations/if.rb` | Tiene `initialize` override - necesita refactor especial |
| `operations/iterable/*.rb` | Más complejas por `push_scope`/`pop_scope` - pero factible |

**Operaciones iterables (map, filter, reduce, all, some, none)**:

Estas operaciones usan `push_scope`/`pop_scope` para crear contexto local. Con métodos estáticos:

```ruby
# Antes (instancia)
class Map < Base
  def call
    input = evaluate(@rules.first)
    input.map do |item|
      scope_stack.push(item)
      result = evaluate(@rules.last)
      scope_stack.pop
      result
    end
  end
end

# Después (estático)
class Map < Base
  def self.call(rules, scope_stack)
    input = evaluate(rules.first, scope_stack)
    input.map do |item|
      scope_stack.push(item)
      result = evaluate(rules.last, scope_stack)
      scope_stack.pop
      result
    end
  end
end
```

El `scope_stack` es mutable, así que el push/pop funciona igual.

**Engine también puede ser estático**:

```ruby
# Antes
Engine.new(rule, scope_stack).call

# Después  
Engine.call(rule, scope_stack)
```

**Impacto estimado**: +50-75% (alcanzar ~500-600k ops/s)
**Riesgo**: Medio (cambio estructural grande, pero mecánico)
**Esfuerzo**: 4-6 horas (57 archivos de operaciones)
**Estrategia**: Hacer en batch con search/replace + ajustes manuales

---

#### 2.2 Cache de operadores instanciados (Object Pool) - ALTERNATIVA

**Concepto**: Pre-instanciar operadores y reutilizar con `reset(args, scope_stack)`.

```ruby
class Engine
  OPERATOR_POOL = {}
  
  def self.get_operator(key)
    OPERATOR_POOL[key] ||= SOLVERS[key].allocate
  end
  
  def call(rule = self.rule)
    # ...
    op = self.class.get_operator(operation_key)
    op.reset(args, scope_stack)
    op.call
  end
end
```

**Problema**: Thread safety. Necesitaría ThreadLocal o pools por thread.

**Impacto estimado**: +30-40%
**Riesgo**: Alto (complejidad, thread safety)
**Esfuerzo**: 1-2 días

---

#### 2.2 Eliminar IndifferentHash, usar transformación upfront

**Concepto**: Transformar data una vez al inicio a formato normalizado.

```ruby
def self.apply(rule, data = {})
  normalized_data = deep_stringify_keys(data)
  # ... usar hash normal con string keys
end
```

**Impacto estimado**: +10-15%
**Riesgo**: Medio (cambio de comportamiento con symbol keys)
**Esfuerzo**: 4 horas

---

#### 2.3 Evaluar sin crear Engine

**Antes** (`base.rb`):
```ruby
def evaluate(rule)
  Engine.new(rule, scope_stack).call
end
```

**Después**:
```ruby
def evaluate(rule)
  Engine.evaluate(rule, scope_stack)  # método de clase, sin instancia
end

# En Engine:
def self.evaluate(rule, scope_stack)
  # lógica directa sin new
end
```

**Impacto estimado**: +10-15%
**Riesgo**: Medio
**Esfuerzo**: 3-4 horas

---

### Fase 3: Rediseño arquitectónico

#### 3.1 Arquitectura híbrida: Lambdas + Clases

**Concepto**: Operadores simples como lambdas, complejos como clases.

```ruby
FAST_OPS = {
  "==" => ->(a, b, _) { a.to_s == b.to_s },
  "===" => ->(a, b, _) { a == b },
  "!" => ->(v, _, _) { !Truthy.call(v) },
  # ...
}.freeze

COMPLEX_OPS = {
  "var" => Operations::Var,
  "map" => Operations::Map,
  # ...
}.freeze

def execute_operation(op, args, scope_stack)
  if FAST_OPS.key?(op)
    evaluated_args = args.map { |a| evaluate(a, scope_stack) }
    FAST_OPS[op].call(*evaluated_args, scope_stack)
  else
    COMPLEX_OPS[op].new(args, scope_stack).call
  end
end
```

**Impacto estimado**: +50-70% para operaciones comunes
**Riesgo**: Alto (duplicación de lógica, mantener paridad)
**Esfuerzo**: 2-3 días

---

#### 3.2 Compilación a Ruby nativo

**Concepto**: Compilar reglas JSON Logic a código Ruby ejecutable.

```ruby
# Input
rule = {"if": [{"==": [{"var": "x"}, 1]}, "yes", "no"]}

# Compilado
compiled = ->(data) {
  data["x"].to_s == "1" ? "yes" : "no"
}

# Ejecución
compiled.call({"x" => 1})  # => "yes"
```

**Impacto estimado**: +200-500% (elimina todo overhead de interpretación)
**Riesgo**: Muy alto (complejidad, edge cases, seguridad)
**Esfuerzo**: 1-2 semanas

---

#### 3.3 YJIT optimizations

Ruby 3.1+ tiene YJIT. Optimizar código para que YJIT lo compile mejor:
- Evitar method_missing
- Tipos consistentes
- Evitar redefenir métodos en runtime

**Impacto estimado**: +20-40% (gratis con YJIT habilitado)
**Riesgo**: Bajo
**Esfuerzo**: Auditoría de 4-6 horas

---

## Plan de ejecución recomendado

### Sprint 1: Quick wins (1-2 días)

| Refactor | Impacto | Prioridad |
|----------|---------|-----------|
| 1.2 Eliminar validate_operators! | +15-25% | **P0** |
| 1.1 Singleton OperatorSolver | +5-10% | **P0** |
| 1.3 Regex para numeric_string | +3-5% | P1 |
| 1.4 Frozen strings | +2-5% | P1 |

**Meta Sprint 1**: Alcanzar 500k ops/s (+50%)

### Sprint 2: Medianos (3-5 días)

| Refactor | Impacto | Prioridad |
|----------|---------|-----------|
| **2.1 Métodos estáticos** | **+50-75%** | **P0** |
| 2.3 Evaluar sin crear Engine | +10-15% | P1 (incluido en 2.1) |
| 2.4 Eliminar IndifferentHash | +10-15% | P1 |
| 2.2 Object Pool | +30-40% | P2 (alternativa a 2.1) |

**Meta Sprint 2**: Alcanzar 1M ops/s (+200% desde inicio)

### Sprint 3: Arquitectura (1-2 semanas)

| Refactor | Impacto | Prioridad |
|----------|---------|-----------|
| 3.1 Híbrido lambdas + clases | +50-70% | **P0** |
| 3.3 YJIT audit | +20-40% | P1 |
| 3.2 Compilación (investigar) | +200-500% | P2 (futuro) |

**Meta Sprint 3**: Alcanzar o superar 3M ops/s (paridad con bhgames)

---

## Métricas de éxito

| Milestone | Ops/s Ruby 4.0 | vs bhgames | vs Kate |
|-----------|----------------|------------|---------|
| Actual | 328k | 11% | +7% |
| Sprint 1 | 500k | 17% | +63% |
| Sprint 2 | 1M | 33% | +227% |
| Sprint 3 | 3M+ | 100%+ | +880% |

---

## Riesgos

| Riesgo | Mitigación |
|--------|------------|
| Romper compatibilidad | Suite de tests completa antes de cada cambio |
| Thread safety con pools | Usar ThreadLocal o evitar estado compartido |
| Over-optimization | Benchmark después de cada cambio, no antes |
| Código menos mantenible | Documentar trade-offs, mantener versión "legacy" |

---

## Benchmark continuo

Después de cada refactor:
```bash
ruby benchmark/performance_benchmark.rb
```

Comparar con baseline y documentar en este archivo.

---

## Referencias

- [bhgames json_logic source](https://github.com/bhgames/json-logic-ruby)
- [Ruby Performance Optimization (book)](https://pragprog.com/titles/adrpo/ruby-performance-optimization/)
- [YJIT documentation](https://github.com/ruby/ruby/blob/master/doc/yjit/yjit.md)
- [Object allocation profiling](https://ruby-doc.org/stdlib/libdoc/objspace/rdoc/ObjectSpace.html)
