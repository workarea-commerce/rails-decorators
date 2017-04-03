module ActiveSupport
  module Dependencies
    module Loadable
      private

      # Monkey patched because Ruby's `require` doesn't load files that don't
      # end in `.rb`, so we have to use `load` for decorators.
      #
      # The difference in semantics between `require` and `load` won't really
      # matter since Rails handles this in development and code doesn't get
      # reloaded in other environments.
      #
      # This module is mixed in to Object.
      #
      def require(file)
        file_string = file.to_s

        if file_string.end_with?(".#{Rails::Decorators.extension}")
          load(file_string)
        else
          super
        end
      end
    end

    # Monkey patched because Rails appends a `.rb` to all files it tries to
    # load with `require_dependency`. It does this for a good reason: both the
    # oob `require` and oob `load` provided by Ruby will accept a path ending
    # with `.rb`. But in our case, we want to ensure that decorators are loaded
    # with `load` since `require` doesn't accept files that don't end with
    # `.rb`.
    #
    def self.load_file(path, const_paths = loadable_constants_for_path(path))
      path = path.gsub(/\.rb\z/, '') if path.end_with?(".#{Rails::Decorators.extension}.rb")

      #
      # Below this copy/pasted from Rails :(
      #
      const_paths = [const_paths].compact unless const_paths.is_a? Array
      parent_paths = const_paths.collect { |const_path| const_path[/.*(?=::)/] || ::Object }

      result = nil
      newly_defined_paths = new_constants_in(*parent_paths) do
        result = Kernel.load path
      end

      autoloaded_constants.concat newly_defined_paths unless load_once_path?(path)
      autoloaded_constants.uniq!
      result
    end
  end
end
