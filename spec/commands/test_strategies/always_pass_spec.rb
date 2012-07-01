require 'spec_helper'

test_class = MountainBerryFields::Test
describe test_class::AlwaysPass do
  it 'is registered it the strategy list under :always_pass' do
    test_class::Strategy.for(:always_pass).should == described_class
  end

  specify '#pass? evaluates the code and returns true even in the face of bullshit' do
    described_class.new("raise Exception, 'this will still pass'").should pass
    $abc = ''
    described_class.new("$abc=123").should pass
    $abc.should == 123
  end
end
