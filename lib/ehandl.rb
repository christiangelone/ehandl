module EHandl

  class ResultCase 
    class Result
      def initialize
        raise 'This should not be instanciated.'
      end

      def method_missing(name, *args, &block) end
    end

    class Success < Result
      def initialize(result)
        @value = result
      end

      def success &proc
        proc.call(@value)
      end
    end

    class Failure < Result
      def initialize(err)
        @value = err
      end
    
      def failure &proc
        proc.call(@value)
      end
    end

    def initialize(expr)
      begin
        result = expr.call
        yield(Success.new(result))
      rescue Exception => ex
        @result = ex
        yield(Failure.new(ex))
      end
    end
  end

  class ExceptionHandling
    def initialize handlers, default
      @ret = nil
      begin 
        @ret = yield()
      rescue Exception => ex
        if(handlers[ex.class].nil?)
          default.call(ex)
        else
          handlers[ex.class].call(ex)
        end
      end
      @ret
    end
  end

  def ehandl_included?
    true
  end
end