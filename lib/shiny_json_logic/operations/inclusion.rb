# frozen_string_literal: true

require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Inclusion < Base
      def call
        needle = evaluate(rules.first)
        haystack = evaluate(rules.last)
        haystack.include?(needle)
      end
    end
  end
end
