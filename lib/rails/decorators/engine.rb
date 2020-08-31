module Rails
  module Decorators
    class Engine < ::Rails::Engine
      isolate_namespace Rails::Decorators

      config.before_initialize do |app|
        app.config.autoloader = :zeitwerk
      end
    end
  end
end
