require 'test_helper'

module Rails
  class DecoratesTest < Minitest::Test
    class TestClass
      def self.foo
        'bar'
      end

      def foo
        'bar'
      end
    end

    module FooModule
      extend Rails::Decorators::Decorator

      module ClassMethodsDecorator
        def foo
          "#{super}|baz"
        end
      end

      decorated { attr_reader :test }

      def foo
        "#{super}|baz"
      end
    end

    def test_decorates
      FooModule.decorates(TestClass)

      assert(TestClass.new.respond_to?(:test))
      assert_equal('bar|baz', TestClass.new.foo)
      assert_equal('bar|baz', TestClass.foo)
    end
  end
end
