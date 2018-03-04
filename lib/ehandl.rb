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
        @result = expr.call
        yield(Success.new(@result))
      rescue Exception => ex
        @result = ex
        yield(Failure.new(@result))
      end
    end
  end

  class ExceptionHandling
    def initialize handlers, default_handler
      begin 
        @value = yield()
      rescue Exception => ex
        @value = ex
        if(handlers[ex.class].nil?)
          default_handler.call(ex)
        else
          handlers[ex.class].call(ex)
        end
      end
      @value
    end
    
    attr_reader :value
  end

  def ehandl_included?
    true
  end
end