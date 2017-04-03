module Rails
  module Decorators
    mattr_accessor :extension
    self.extension = :decorator
  end
end

require 'rails/decorators/engine'
require 'rails/decorators/version'
require 'rails/decorators/application'
require 'rails/decorators/active_support'
require 'rails/decorators/decorator'
require 'rails/decorators/invalid_decorator'
require 'rails/decorators/object'
