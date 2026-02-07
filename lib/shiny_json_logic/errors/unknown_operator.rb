module ShinyJsonLogic
  module Errors
    class UnknownOperator < Base
      def initialize
        super(type: "Unknown Operator")
      end
    end
  end
end
