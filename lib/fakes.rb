require 'developwithpassion_arrays'

require 'core/arg_matching/arg_match_factory'
require 'core/arg_matching/block_arg_matcher'
require 'core/arg_matching/combined_arg_matcher'
require 'core/arg_matching/matches'
require 'core/arg_matching/regular_arg_matcher'
require 'core/arg_behaviour'
require 'core/arg_set'
require 'core/class_swap'
require 'core/class_swaps'
require 'core/fake'
require 'core/ignore_set'
require 'core/method_stub'
require 'singleton'

class Object
  def fake
    return Fakes::Fake.new
  end
  def arg_match
    return Fakes::Matches
  end
  def fake_class(klass)
    item = fake
    Fakes::ClassSwaps.instance.add_fake_for(klass,item)
    item
  end
  def reset_fake_classes
    Fakes::ClassSwaps.instance.reset
  end
end
