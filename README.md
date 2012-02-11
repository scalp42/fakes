#developwithpassion_fakes

This is a really simple library to aid in AAA style testing. The primary driver for using this is to be able to make assertions on method calls to collaborators in actual assertions and not as part of setup.

Here is a simple example

```ruby
class SomeClass
  def initialize(collaborator)
    @collaborator = collaborator
  end
  def run()
    @collaborator.send_message("Hi")
  end
end

describe SomeClass do
 context "when run" do
  let(:collaborator){DevelopWithPassion::Fakes::Fake.new}
  let(:sut){SomeClass.new(collaborator)}

  before(:each) do
    sut.run
  end

  it "should trigger its collaborator with the correct message" do
    collaborator.received(:send_message).called_with("Hi").should_not be_nil
  end
 end
end
```

##Creating a new fake

To create a new fake, simple instantiate a class of DevelopWithPassion::Fakes::Fake. If you don't wish to keep typing that out, I would recommend creating a simple factory method in your test utility file. I typically use a file called spec_helper that is included in all of the test files. I will place the following code in spec_helper (sample) :

```ruby
require 'rspec'
require 'developwithpassion_fakes'

def fake
  return DevelopWithPassion::Fakes::Fake.new
end
```
As you can see, this makes the process of creating a fake much simpler from a test.

##Specifying the behaviour of a fake

When scaffolding fake return values, the library behaves almost identically to the way RSpec stubs work. 

###Setup a method to return a value for a particular set of arguments
```ruby
collaborator = fake

collaborator.stub(:name_of_method).with(arg1,arg2,arg3).and_return(return_value)
```

###Setup a method to return a value regardless of the arguments it is called with
```ruby
collaborator = fake

#long handed way
collaborator.stub(:name_of_method).ignore_arg.and_return(return_value)

#preferred way
collaborator.stub(:name_of_method).and_return(return_value)
```

###Setup different return values for different argument sets
```ruby
collaborator = fake

#Setup a return value for 1
collaborator.stub(:method).with(1).and_return(first_return_value)

#Setup a return value for 2
collaborator.stub(:method).with(2).and_return(second_return_value)

#Setup a return value when called with everything else 
#if you are going to use this, make sure it is used after 
#setting up return values for specific arguments
collaborator.stub(:method).and_return(value_to_return_with_arguments_other_than_1_and_2)
```

##Veryfying calls made to the fake

The primary purpose of the library is to help you in doing interaction style testing in a AAA style. Again assume the following class is one you would like to test:

```ruby
class ItemToTest
  def initialize(collaborator)
    @collaborator = collaborator
  end

  def run
    @collaborator.send_message("Hello World")
  end
end
```

ItemToTest is supposed to leverage its collaborator and calls its send_message method with the argument "Hello World". To verify this using AAA style, interaction testing you can do the following (I am using rspec, but you can use this with any testing library you wish):

```ruby
describe ItemToTest do
 context "when run" do
  let(:collaborator){fake}
  let(:sut){ItemToTest.new(collaborator)}

  #I typically use a before block to specifically trigger the method that I am testing, so it cleanly
  #separates it from the assertions I will make later
  before(:each) do
    sut.run
  end

  it "should trigger its collaborator with the correct message" do
    collaborator.received(:send_message).called_with("Hello World").should_not be_nil
  end
 end
end
```
From the example above, you can see that we created the fake and did not need to scaffold it with any behaviour. 
```ruby
let(:collaborator){fake}
```
You can also see that we are instantiation our System Under Test (sut) and providing it the collaborator:
```ruby
let(:sut){ItemToTest.new(collaborator)}
```

We then proceed to invoke the method on the component we are testing
```ruby
before(:each) do
  sut.run
end
```

Last but not least, we verify that our collaborator was invoked and with the right arguments:
```ruby
it "should trigger its collaborator with the correct message" do
  collaborator.received(:send_message).called_with("Hello World").should_not be_nil
end
```
The nice thing is we can make the assertions after the fact, as opposed to needing to do them as part of setup, which I find is a much more natural way to read things, when you need to do this style of test.
