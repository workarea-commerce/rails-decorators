module Zeitwerk
  class Loader
    module RailsDecorators
      def do_preload
        super
        load_decorators
      end

      def load_decorators
        decorator_ext = /\.#{Rails::Decorators.extension}$/
        queue = []
        actual_root_dirs.each do |root_dir, namespace|
          queue << [namespace, root_dir] unless eager_load_exclusions.member?(root_dir)
        end

        while dir_to_load = queue.shift
          namespace, dir = dir_to_load

          ls(dir) do |basename, abspath|
            if abspath =~ decorator_ext
              load(abspath)
            elsif dir?(abspath) && !root_dirs.key?(abspath)
              if collapse_dirs.member?(abspath)
                queue << [namespace, abspath]
              else
                cname = inflector.camelize(basename, abspath)
                queue << [namespace.const_get(cname, false), abspath]
              end
            end
          end
        end
      end
    end

    prepend RailsDecorators
  end
end
