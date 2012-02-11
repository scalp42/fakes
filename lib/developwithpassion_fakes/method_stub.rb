module DevelopWithPassion
  module Fakes
    class MethodStub
      def initialize(arg_sets = [])
        @arg_sets = arg_sets
      end

      def with(*args)
        return add_new_set(ArgSet.new(*args))
      end

      def add_new_set(set)
        @arg_sets << set
        return set
      end

      def ignore_arg
        return add_new_set(IgnoreSet.new)
      end

      def and_return(item)
        ignore_arg.and_return(item)
      end


      def invoke(*args)
        set = @arg_sets.find{|item| item.matches?(*args)} || ignore_arg
        set.capture_args(*args)
        return set.return_value
      end

      def called_with(*args)
        return @arg_sets.find{|item| item.was_called_with?(*args)}
      end

      def times?(value)
        total = @arg_sets.inject(0){|sum,item|sum += item.times_called}
        return total == value
      end
    end
  end
end