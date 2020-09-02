module Rails
  module Decorators
    class MissingZeitwerkError < StandardError; end

    class Engine < ::Rails::Engine
      isolate_namespace Rails::Decorators

      config.after_initialize do |app|
        unless Rails.configuration.autoloader == :zeitwerk
          raise MissingZeitwerkError, <<-eos.strip_heredoc
            rails-decorators requires using the Zeitwerk code loader. You can set this in config/application.rb by doing `config.autoloader = :zeitwerk`
          eos
        end
      end
    end
  end
end
