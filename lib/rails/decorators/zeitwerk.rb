module Zeitwerk
  class Loader
    module RailsDecorators
      # Registers an on_setup callback that loads all decorator files
      # found under this loader's root directories. Called by the engine.
      def register_rails_decorators
        on_setup do
          load_decorator_files
        end
      end

      private

      def load_decorator_files
        decorator_ext = ".#{Rails::Decorators.extension}"
        roots_hash = instance_variable_get(:@roots) || {}
        exclusions = instance_variable_get(:@eager_load_exclusions) || Set.new

        roots_hash.each_key do |root_dir|
          next if exclusions.member?(root_dir)

          Dir.glob("#{root_dir}/**/*#{decorator_ext}").sort.each do |abspath|
            load(abspath)
          end
        end
      end
    end

    prepend RailsDecorators
  end
end
