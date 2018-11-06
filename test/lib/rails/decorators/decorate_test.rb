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

  module Namespace
    class TestClass < TestClass
      def foo
        'baz'
      end
    end
  end

  class ChildClass < TestClass
  end

  decorate(TestClass, with: 'testing') do
    class_methods do
      def foo
        "#{super}|baz"
      end
    end

    before_decorate { alias_method :foobar, :foo }
    decorated { attr_reader :test }

    def foo
      "#{super}|baz"
    end
  end

  decorate(ChildClass, with: 'testing') do
    def baz
      'decorated'
    end
  end

  decorate(Namespace::TestClass, with: 'testing') do
    def foo
      'namespace decorated'
    end
  end

  def test_decorate
    assert(TestClass.new.respond_to?(:test))
    assert_equal('bar|baz', TestClass.new.foo)
    assert_equal('bar|baz', TestClass.foo)
    assert_equal('bar', TestClass.new.foobar)
  end

  def test_subclass_decoration
    assert_equal('decorated', ChildClass.new.baz)
  end

  def test_decorating_within_a_namespace
    assert_equal('namespace decorated', Namespace::TestClass.new.foo)
  end

  def test_module_definition
    decorate(TestClass, with: 'more_tests') {}
    assert(TestClass.const_defined?(:MoreTestsDecorateTestTestClassDecorator))
  end
end
