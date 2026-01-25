module ShinyJsonLogic
  module Errors
    class Base < StandardError
      attr_reader :type

      def initialize(type: nil)
        super(type)
        @type = type
      end

      def payload
        @payload ||= { "type" => type }
      end
    end
  end
end