module ShinyJsonLogic
  module Numericals
    module WithErrorHandling
      def safe_arithmetic(&block)
        result = yield
        result.tap do |res|
          if res.to_f.nan? || res == Float::INFINITY || res == -Float::INFINITY
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