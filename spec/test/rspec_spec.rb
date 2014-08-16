require 'spec_helper'

RSpec.describe MountainBerryFields::Test::RSpec do
  it 'is registered it the strategy list under :rspec' do
    expect(MountainBerryFields::Test::Strategy.for :rspec).to eq described_class
  end

  let(:passing_spec) { <<-EOF.gsub /^ {4}/, '' }
    describe 'an example' do
      it('passes') { expect(true).to eq true }
    end
  EOF

  let(:failing_spec) { <<-EOF.gsub /^ {4}/, '' }
    describe 'an example' do
      it('fails') { expect(true)to eq(false), 'the message' }
    end
  EOF

  let(:spec_with_two_failures) { <<-EOF.gsub /^ {4}/, '' }
    describe 'an example' do
      it('fails 1') { expect(true).to eq false, 'failure message 1' }
      it('fails 2') { expect(true).to eq false, 'failure message 2' }
    end
  EOF

  let(:the_spec)    { passing_spec }

  it 'checks input syntax first' do
    rspec = described_class.new the_spec
    syntax_checker = rspec.syntax_checker
    expect(syntax_checker).was initialized_with the_spec
    syntax_checker.will_have_valid? false  # rename to valid_syntax
    syntax_checker.will_have_invalid_message "you call that code?"
    expect(rspec).to_not pass
    expect(rspec.failure_message).to eq "you call that code?"
  end

  it 'pulls its failure message from the JSON output of the results, showing the description, message, and backtrace without the temp dir', t:true do
    rspec = described_class.new(the_spec)
    rspec.pass?
    expect(rspec.failure_message).to include 'THE DESCRIPTION'
    expect(rspec.failure_message).to include 'THE MESSAGE'
    expect(rspec.failure_message).to include 'THE BACKTRACE'
  end
end
