require 'test_helper'

module Rails
  class InvalidDecorationTest < Minitest::Test
    class TestClass
    end

    module TestModule
    end

    def test_duplicate_decorating
      decorate(TestClass, with: 'testing') {}

      assert_raises(Rails::Decorators::InvalidDecorator) do
        decorate(TestClass, with: 'testing') {}
      end
    end

    def test_module_decorating
      assert_raises(Rails::Decorators::InvalidDecorator) do
        decorate(TestModule) {}
      end
    end
  end
end
