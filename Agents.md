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
- `+` (addition.rb) - Usa `Array.wrap_nil(rules).each`
- `val` (val.rb) - Usa `Array.wrap_nil(rules)`
- `var` (var.rb) - Usa `Array.wrap_nil(rules)`
- `max` (max.rb) - Usa `Array.wrap_nil(rules).each`
- `cat` (concatenation.rb) - Usa `Array.wrap_nil(rules).each`
- `merge` (merge.rb) - Usa `Array.wrap_nil(rules).map`
- `exists` (exists.rb) - Usa `Array.wrap_nil(rules).each` (también eliminado O(n²))
- `missing` (missing.rb) - Usa `Array.wrap_nil(rules)` y quitado chequeo innecesario

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
- **Compatibilidad estándar (bin/test.sh):** 894/1126 (79.4%)
- **Objetivo:** 84% mínimo

## Operaciones Pendientes de Arreglar

Los fallos restantes están principalmente en:

1. **Operadores de comparación** (muchos fallos):
   - `>` (greater.rb)
   - `>=` (greater_equal.rb)
   - `<` (smaller.rb)
   - `<=` (smaller_equal.rb)
   - `==` (equal.rb)
   - `!=` (different.rb)
   - `===` (strict_equal.rb)
   - `!==` (strict_different.rb)

2. **Operaciones aritméticas**:
   - `-` (subtraction.rb)
   - `/` (division.rb)
   - `%` (modulo.rb)
   - `*` (product.rb)

3. **Otras**:
   - `and` (and.rb) - casos edge
   - `or` (or.rb) - probablemente similar
   - `if` (if.rb)
   - `all`, `some`, `none` - casos con arrays faltantes

## Patrón de Arreglo

Para cada operación que falla, el patrón general es:

1. Identificar dónde asume que `rules` es un array (ej: `rules.each`, `rules.first`, `rules[0]`)
2. Envolver con `Array.wrap_nil(rules)` para manejar valores unitarios
3. Verificar que no se esté haciendo aplanado innecesario (mantener O(n))

## Cómo Continuar

1. Correr `bundle exec rspec` para verificar tests internos
2. Correr `bin/test.sh` para ver compatibilidad estándar
3. Identificar operación con fallos
4. Ver casos de test que fallan para esa operación
5. Modificar la operación siguiendo el patrón
6. Repetir hasta alcanzar 84%+

## Comandos Útiles

```bash
# Tests internos
bundle exec rspec

# Tests de compatibilidad estándar
bin/test.sh

# Ver fallos por operación
bin/test.sh 2>&1 | grep "FAILED" | head -50

# Probar operación específica
bundle exec ruby -e "
require 'bundler/setup'
require 'shiny_json_logic'
result = ShinyJsonLogic.apply({'operador' => args}, data)
puts result.inspect
"
```
