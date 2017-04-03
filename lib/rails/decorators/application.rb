module Rails
  class Application < Engine
    module Decorators
      def watchable_args
        result = super

        result.last.keys.each do |path|
          result.last[path] << Rails::Decorators.extension
        end

        result
      end
    end

    prepend Decorators
  end
end
