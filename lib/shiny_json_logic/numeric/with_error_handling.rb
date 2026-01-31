module ShinyJsonLogic
  module Numeric
    module WithErrorHandling
      def safe_arithmetic(&block)
        result = yield
        result.tap do |res|
          if res.nan? || res.infinite?
            self.data["type"] = "NaN"
            error = ShinyJsonLogic::Errors::Base.new(type: "NaN")
            errors.push error
            return error.id
          end
        end
      end
    end
  end
end