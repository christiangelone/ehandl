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
      end
      result.failure do |ex|
        assert_true(false, ['should not execute!'])
      end
    end
    #p obtained
    assert_equal(ResultCase,obtained.class)
  end

  def test_failure
    obtained = ResultCase.new(proc {2 / 0}) do |result|
      result.success do |value|
        assert_true(false, ['should not execute!'])
      end
      result.failure do |ex|
        assert_equal(ZeroDivisionError,ex.class)
      end
    end
    #p obtained
    assert_equal(ResultCase,obtained.class)
  end

  class MyException < Exception
    def initialize msg
      super(msg)
    end
  end

  def test_exception_handling
    obtained = ExceptionHandling.new({
      MyException => proc { |ex|
        assert_true(ex.is_a?(MyException))
      }
    },proc { |ex|
      assert_true(false)
      p ex.message
    }) do
      raise MyException.new 'My Boom!'
      :not_returned
    end
    #p obtained
    assert_equal(ExceptionHandling,obtained.class)
    assert_equal(obtained.value.message,'My Boom!')
  end

  def test_exception_handling_default
    obtained = ExceptionHandling.new({}, proc { |ex|
      assert_equal('Boom!', ex.message)
    }) do
      raise Exception.new 'Boom!'
      :not_returned
    end
    #p obtained
    assert_equal(ExceptionHandling,obtained.class)
    assert_equal(obtained.value.message,'Boom!')
  end

  def test_exception_handling_no_exception
    obtained = ExceptionHandling.new({}, proc { |ex|
      assert_equal('Boom!', ex.message)
    }) do
      2 + 2
    end
    #p obtained
    assert_equal(ExceptionHandling,obtained.class)
    assert_equal(4,obtained.value)    
  end
end