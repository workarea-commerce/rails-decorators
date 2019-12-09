module Rails
  module Decorators
    class Engine < ::Rails::Engine
      isolate_namespace Rails::Decorators

      config.before_initialize do |app|
        app.config.autoloader = :classic

        engines = Rails::Engine.subclasses

        loader = Decorator.loader(engines.map(&:root) + [Rails.root])
        app.config.to_prepare(&loader)
      end
    end
  end
end
