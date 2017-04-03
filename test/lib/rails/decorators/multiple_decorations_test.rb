require 'test_helper'

module Rails
  class MultipleDecorationsTest < Minitest::Test
    class One
      def self.foo
        '1'
      end

      def foo
        '1'
      end
    end

    class Two
      def self.foo
        '2'
      end

      def foo
        '2'
      end
    end

    def test_can_decorate_multiple_classes_at_once
      decorate(One, Two, with: 'testing') do
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

      assert(One.new.respond_to?(:test))
      assert_equal('1|baz', One.new.foo)
      assert_equal('1|baz', One.foo)

      assert(Two.new.respond_to?(:test))
      assert_equal('2|baz', Two.new.foo)
      assert_equal('2|baz', Two.foo)
    end
  end
end
