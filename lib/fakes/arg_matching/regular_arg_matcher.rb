module Fakes
  class RegularArgMatcher
    def initialize(value_to_match)
      @value_to_match = value_to_match
    end

    def matches?(item)
      @value_to_match == item
    end
  end
end
