require 'test_helper'

class DecorateTest < Minitest::Test
  class TestClass
    def self.foo
      'bar'
    end

    def foo
      'bar'
    end
  end

  class ChildClass < TestClass
  end

  def test_decorate
    decorate(TestClass, with: 'testing') do
      class_methods do
        def foo
          "#{super}|baz"
        end
      end

      decorated { attr_reader :test }

      def foo
        "#{super}|baz"
      end
    end

    assert(TestClass.new.respond_to?(:test))
    assert_equal('bar|baz', TestClass.new.foo)
    assert_equal('bar|baz', TestClass.foo)
  end

  def test_subclass_decoration
    decorate(ChildClass, with: 'testing') do
      def baz
        'decorated'
      end
    end

    assert_equal('decorated', ChildClass.new.baz)
  end

  def test_module_definition
    decorate(TestClass, with: 'tests') {}
    assert(TestClass.const_defined?(:TestsTestClassDecorator))
  end
end
