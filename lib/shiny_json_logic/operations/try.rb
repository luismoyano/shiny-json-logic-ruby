require "core_ext/array"

module ShinyJsonLogic
  module Operations
    class Try < Base
      SHINY_ERROR_PATTERN = /shiny_error_[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/i

      protected

      def run
        rules.map do |item|
          Engine.new(item, data).call
        end.then do |results|
          # binding.pry
          return results.first unless results.count > 1

          results[0..-2].each do|res|
            if res.is_a?(String) && res.match?(SHINY_ERROR_PATTERN) && errors.first.id == res
              errors.shift
              data.delete("type")
              p "TRY OPERATION CAUGHT AN ERROR: #{res}"
            end
          end

          results.last
        end
      end
    end
  end
end