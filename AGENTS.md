# Estado del Refactor: Eliminar Syntactic Sugar de Array.wrap_nil en Engine

## Instrucciones para el Agente

**IMPORTANTE:** Antes de modificar cualquier fichero:
1. Explicar qué cambio se va a hacer y por qué
2. Preguntar al usuario si procedemos o no
3. Solo modificar tras confirmación explícita

## Contexto

Estamos refactorizando la implementación de JSONLogic para Ruby para eliminar el "syntactic sugar" que convertía automáticamente todos los argumentos a arrays en `engine.rb:20`.

### Cambio Principal

**Antes:**
```ruby
operation, raw_args = rule.to_a.first
args = Array.wrap_nil(raw_args)
solve(operation, args, data)
```

**Después:**
```ruby
operation, raw_args = rule.to_a.first
solve(operation, raw_args, data)
```

## Filosofía

En JSONLogic:
- Las operaciones deben ser O(n), nunca O(n²)
- Si un argumento es un hash con operador, se evalúa en el preprocesado de `base.rb`
- Si un argumento es un array, ES un array (no se aplana)
- Si un argumento es un valor unitario (número, string, boolean, nil, hash vacío), se maneja como tal

## Progreso

### Operaciones Arregladas
- `!` (not.rb) - Usa `rules.is_a?(Array) ? rules.first : rules`
- `+` (addition.rb) - Usa `Array.wrap_nil(rules).each`, sin aplanar resultado de evaluate
- `val` (val.rb) - Usa `Array.wrap_nil(rules)`
- `var` (var.rb) - Usa `Array.wrap_nil(rules)`
- `max` (max.rb) - Usa `Array.wrap_nil(rules).each`
- `cat` (concatenation.rb) - Usa `Array.wrap_nil(rules).each`
- `merge` (merge.rb) - Usa `Array.wrap_nil(rules).map`
- `exists` (exists.rb) - Usa `Array.wrap_nil(rules).each` (también eliminado O(n²))
- `missing` (missing.rb) - Usa `Array.wrap_nil(rules)` y quitado chequeo innecesario
- `-` (subtraction.rb) - Usa `Array.wrap_nil(rules)` para manejar argumentos directos
- `/` (division.rb) - Usa `Array.wrap_nil(rules)` para manejar argumentos directos
- `%` (modulo.rb) - Usa `Array.wrap_nil(rules)` para manejar argumentos directos
- `*` (product.rb) - Usa `Array.wrap_nil(rules)` para manejar argumentos directos
- `>` (greater.rb) - Reescrito con comparación de tipos, NaN para arrays/objetos
- `>=` (greater_equal.rb) - Reescrito con comparación de tipos
- `<` (smaller.rb) - Reescrito con comparación de tipos
- `<=` (smaller_equal.rb) - Reescrito con comparación de tipos
- `==` (equal.rb) - Reescrito con coerción de tipos y manejo de NaN
- `!=` (different.rb) - Reescrito con comparación consecutiva de pares
- `===` (strict_equal.rb) - Añadida validación de argumentos mínimos
- `!==` (strict_different.rb) - Reescrito con comparación consecutiva de pares

### Módulo WithErrorHandling
Se centralizó el manejo de errores en `lib/shiny_json_logic/numericals/with_error_handling.rb`:
- `handle_nan` - Retorna error de tipo "NaN"
- `handle_invalid_args` - Retorna error de tipo "Invalid Arguments"
- Aliases para compatibilidad: `handle_invalid_operand`, `handle_no_operators`

### Preprocesado en base.rb
Se añadió preprocesado que evalúa hashes con operadores antes de pasarlos a la operación:
```ruby
def preprocess(rules)
  if operation?(rules)
    evaluate(rules)
  else
    rules
  end
end
```

## Estado Actual

- **Tests internos (spec/):** 315/315 pasando (100%)
- **Compatibilidad estándar (bin/test.sh):** 1041/1126 (92.5%)
- **Objetivo:** 84% mínimo ✅ ALCANZADO

## Operaciones Pendientes de Arreglar

Los fallos restantes (85) están principalmente en:

1. **Operadores con argumentos dinámicos** - Casos donde se pasa un array dinámico via `preserve`
2. **`all`, `some`, `none`** - Casos "Missing array returns error"
3. **`and`, `or`, `if`** - Casos edge con argumentos no-array

## Patrón de Arreglo

Para cada operación que falla, el patrón general es:

1. Identificar dónde asume que `rules` es un array (ej: `rules.each`, `rules.first`, `rules[0]`)
2. Envolver con `Array.wrap_nil(rules)` para manejar valores unitarios
3. Incluir `Numericals::WithErrorHandling` para usar `handle_nan` y `handle_invalid_args`
4. Verificar que no se esté haciendo aplanado innecesario (mantener O(n))

## Cómo Continuar

1. Correr `bundle exec rspec` para verificar tests internos
2. Correr `bin/test.sh` para ver compatibilidad estándar
3. Identificar operación con fallos
4. Ver casos de test que fallan para esa operación
5. Modificar la operación siguiendo el patrón
6. Repetir

## Comandos Útiles

```bash
# Tests internos
bundle exec rspec

# Tests de compatibilidad estándar
bin/test.sh

# Ver fallos por operación
bin/test.sh 2>&1 | grep -B1 "FAILED" | grep "example" | head -50

# Probar operación específica
bundle exec ruby -e "
require 'bundler/setup'
require 'shiny_json_logic'
result = ShinyJsonLogic.apply({'operador' => args}, data)
puts result.inspect
"
```
