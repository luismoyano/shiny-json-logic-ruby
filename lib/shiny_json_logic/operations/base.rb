require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    class Base
      def initialize(context)
        @context = context
        @rules, @data, @errors = @context.values_at("rules", "data", "errors")
        @rules = preprocess_preserve(@rules)
      end

      def call
        deliver run
      end

      protected

      attr_reader :context
      attr_accessor :rules, :data, :errors

      def run
        raise NotImplementedError
      end

      def deliver(result = nil)
        {"result" => result, "data" => self.data, "errors" => self.errors}
      end

      # Evalúa un argumento raw usando el Engine
      def evaluate(rule)
        engine = Engine.new(rule, data)
        result = engine.call
        self.errors = [*errors, *engine.errors].uniq
        result
      end

      private

      # Pre-procesa las rules buscando hashes con key "preserve".
      # Si encuentra uno, lo evalúa inmediatamente y expande el resultado en el array de rules.
      # Ejemplo: [{"preserve" => [7, 8]}] -> [7, 8]
      # Ejemplo: [1, {"preserve" => [2, 3]}, 4] -> [1, 2, 3, 4]
      def preprocess_preserve(rules)
        # Si rules mismo es un hash con "preserve", evaluarlo y devolver el resultado
        if rules.is_a?(Hash) && rules.key?("preserve")
          return evaluate(rules["preserve"])
        end

        return rules unless rules.is_a?(Array)

        result = []
        rules.each do |rule|
          if rule.is_a?(Hash) && rule.key?("preserve")
            evaluated = evaluate(rule["preserve"])
            # Expandir el resultado si es un array
            if evaluated.is_a?(Array)
              result.concat(evaluated)
            else
              result << evaluated
            end
          else
            result << rule
          end
        end
        result
      end
    end
  end
end
