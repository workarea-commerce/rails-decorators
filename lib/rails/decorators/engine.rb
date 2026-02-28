module Rails
  module Decorators
    class MissingZeitwerkError < StandardError; end

    class Engine < ::Rails::Engine
      isolate_namespace Rails::Decorators

      config.after_initialize do |app|
        # Rails < 8 had config.autoloader; Rails 8+ always uses Zeitwerk.
        if Rails.configuration.respond_to?(:autoloader)
          unless Rails.configuration.autoloader == :zeitwerk
            raise MissingZeitwerkError, <<-eos.strip_heredoc
              rails-decorators requires using the Zeitwerk code loader. You can set this in config/application.rb by doing `config.autoloader = :zeitwerk`
            eos
          end
        end

        # Register decorator loading on each Zeitwerk loader used by Rails.
        Rails.autoloaders.each do |loader|
          loader.register_rails_decorators
        end
      end
    end
  end
end
