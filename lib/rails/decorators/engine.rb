module Rails
  module Decorators
    class Engine < ::Rails::Engine
      isolate_namespace Rails::Decorators

      config.before_initialize do |app|
        engines = ObjectSpace
                    .each_object(Class)
                    .select { |klass| klass < ::Rails::Engine }
                    .select { |klass| klass.name.present? }
                    .select { |klass| klass != ::Rails::Application }

        loader = Decorator.loader(engines.map(&:root) + [Rails.root])
        app.config.to_prepare(&loader)
      end
    end
  end
end
