require 'test_helper'

class DecoratorLoadingTest < Minitest::Test
  def test_loads_decorators_from_host_app
    assert_equal('bar baz', Rails::Decorators::TestModel.new.foo)
  end

  def test_loads_decorators_from_engine
    assert(Rails::Decorators.const_defined?('TestDecorator'))
  end
end
