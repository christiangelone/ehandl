# EHandl
### A ruby gem for handling exceptions

## Install

  ~$ gem install ehandl
  
## Usage

```ruby
  require 'ehandl'
  include EHandl
```
## Success/Failure Handling

```ruby
obtained = ResultCase.new(proc {2 / 0}) do |result|
  result.success do |value|
    puts "The operation succeed: #{value}"
  end
  result.failure do |ex|
    puts "The operation failed because: #{ex.message}"
  end
end
# The operation failed because: divided by 0
# obtained ~> #<EHandl::ResultCase @result=#<ZeroDivisionError: divided by 0>>
```

## Multiple Exception Handling

```ruby
obtained = ExceptionHandling.new({
  MyException => proc { |ex|
    puts "Caught by MyException handler: #{ex.message}"
  },
  OtherException => proc { |ex|
    puts "Caught by OtherException handler: #{ex.message}"
  }
}, proc { |ex|
  puts "Caught by default handler: #{ex.message}"
}) do
  raise MyException.new 'My Boom!'
  :not_returned
end
# Caught by MyException handler: My Boom!
# obtained ~> #<EHandl::ExceptionHandling @value=#<MyException: My Boom!>>
```
