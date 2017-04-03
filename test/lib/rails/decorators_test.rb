require 'test_helper'

module Rails
  class DecoratorsTest < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil ::Rails::Decorators::VERSION
    end
  end
end
