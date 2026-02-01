require "securerandom"

module ShinyJsonLogic
  module Errors
    class Base < StandardError
      attr_reader :type, :id
      attr_accessor :panic

      def initialize(type: nil)
        super(type)
        @type = type
        @id = "shiny_error_#{SecureRandom.uuid}"
      end

      def payload
        @payload ||= { "type" => type }
      end
    end
  end
end