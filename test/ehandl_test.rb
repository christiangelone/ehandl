require_relative '../lib/ehandl'
require 'test/unit'

class TestEhandl < Test::Unit::TestCase

  include EHandl

  def test_ehandl_included?
    assert_true(ehandl_included?)
  end

  def test_success
    obtained = ResultCase.new(proc {2 + 2}) do |result|
      result.success do |value|
        assert_equal(4,value)
        return value + 3
      end
      result.failure do |ex|
        assert_true(false, ['should not execute!'])
        return :imposible
      end
    end
    assert_equal(7,obtained)
  end

  def test_failure
    obtained = ResultCase.new(proc {2 / 0}) do |result|
      result.success do |value|
        assert_true(false, ['should not execute!'])
        return :imposible
      end
      result.failure do |ex|
        assert_not_nil ex
        return :infinity
      end
    end
    assert_equal(:infinity,obtained)
  end

  class MyException < Exception
  end

  def test_exception_handling
    ExceptionHandling.new({
      MyException => proc { |ex|
        assert_true(ex.is_a?(MyException))
      }
    },proc { |ex|
      assert_true(false)
      p ex.message
    }) do
      raise MyException.new
      return :not_returned
    end
  end

  def test_exception_handling_default
    ExceptionHandling.new({}, proc { |ex|
      assert_equal('Boom!', ex.message)
    }) do
      raise Exception.new 'Boom!'
      return :not_returned
    end
  end

  def test_exception_handling_no_exception
    obtained = ExceptionHandling.new({}, proc { |ex|
      assert_equal('Boom!', ex.message)
    }) do
      return 4 + 4
    end
    assert_equal(8, obtained)
  end
end