require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Throw < Base
      def call
        raw_value = rules.is_a?(Array) ? rules[0] : rules

        error_type =
          if operation?(raw_value)
            evaluate(raw_value)
          else
            raw_value
          end

        extracted_type = error_type.is_a?(Hash) && error_type.key?("type") ? error_type["type"] : error_type
        extracted_type = self.data["type"] if extracted_type.nil?
        self.data["type"] = extracted_type unless extracted_type.nil?

        error = Errors::Base.new(type: extracted_type)

        raise error
      end
    end
  end
end
