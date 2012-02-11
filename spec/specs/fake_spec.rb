require 'spec_helper'

module DevelopWithPassion
  module Fakes
    describe Fake do
      context "when stubbing a method" do
        let(:invocations){Hash.new}
        let(:sut){Fake.new(invocations)}
        let(:symbol){:hello}
        let(:new_method){Object.new}

        context "and the method is not currently setup to be called" do
          before (:each) do
            MethodStub.stub(:new).and_return(new_method)
          end
          before (:each) do
            @result = sut.stub(symbol)
          end
          it "should add a new method stub to the list of all invocations" do
            invocations[symbol].should == new_method
          end
          it "should return the method invocation to continue specifying call behaviour" do
            @result.should == new_method 
          end
        end

        context "and the method is already in the list of invocations" do
          before (:each) do
            invocations[symbol] = new_method
          end
          before (:each) do
            @result = sut.stub(symbol)
          end

          it "should not readd the method to the list of invocations" do
            invocations.count.should == 1
          end

          it "should return the method invocation to continue specifying call behaviour" do
            @result.should == new_method 
          end
        end
      end
      context "when accessing the behaviour for a received call" do
        let(:invocations){Hash.new}
        let(:sut){Fake.new(invocations)}
        let(:symbol){:hello}
        let(:method_invocation){Object.new}

        before (:each) do
          invocations[symbol] = method_invocation
        end
        before (:each) do
          @result = sut.received(symbol)
        end
        it "should return the method invocation for the called method" do
          @result.should == method_invocation 
        end
      end
      context "when verifying whether a call was never received" do
        let(:invocations){Hash.new}
        let(:sut){Fake.new(invocations)}
        let(:existing){:hello}
        let(:method_invocation){Object.new}

        before (:each) do
          invocations[existing] = method_invocation
        end


        it "should base its decision on the list of received invocations" do
          [:other,existing].each do|item|
            sut.never_received?(item).should_not be_equal(invocations.has_key?(item))
          end
        end
      end
      context "when method missing is triggered" do
        class FakeInvocation
          attr_accessor :invoke_was_called,:args,:return_value,:ignores_args

          def initialize(return_value)
            @return_value = return_value
          end

          def invoke(args)
            @args = args
            return @return_value
          end

          def ignore_arg
            @ignores_args = true
          end
        end
        let(:invocations){Hash.new}
        let(:sut){Fake.new(invocations)}
        let(:symbol){:hello}
        let(:invocation){FakeInvocation.new(Object.new)}
        let(:args){"world"}
        context "and the method is for an invocation that was prepared" do
          before (:each) do
            invocations[symbol] = invocation
          end
          before (:each) do
            @result = sut.hello(args)
          end
          it "should trigger the invocation with the arguments" do
            invocation.args.should == args
          end
          it "should return the result of triggering the invocation" do
            @result.should == invocation.return_value
          end
        end
        context "and the method is for an invocation that was not prepared" do
          before (:each) do
            MethodStub.stub(:new).and_return(invocation)
          end
          before (:each) do
            @result = sut.hello(args)
          end
          it "should add a new invocation which ignores arguments to the list of all invocations" do
            invocations.has_key?(:hello).should be_true
          end

          it "should configure the new invocation to ignore all arguments" do
            invocation.ignores_args.should be_true 
          end

          it "should invoke the invocation with the arguments" do
            invocation.args.should == args 
          end

          it "should return the result of triggering the new invocation" do
            @result.should == invocation.return_value
          end
        end

      end
    end
  end
end