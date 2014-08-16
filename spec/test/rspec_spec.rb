require 'spec_helper'

describe MountainBerryFields::Test::RSpec do
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

  let(:file_class)  { Mock::File.clone }
  let(:dir_class)   { Mock::Dir.clone }
  let(:open3_class) { Mock::Open3.clone }
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

  it 'writes the file to a temp dir' do
    rspec = described_class.new(the_spec).with_dependencies(dir_class: dir_class, file_class: file_class, open3_class: open3_class)
    dir_class.will_mktmpdir true
    rspec.pass?
    expect(rspec.dir_class).was told_to(:mktmpdir).with('mountain_berry_fields_rspec') { |block|
      block.call_with '/temp_dir'
      block.before { expect(file_class).was_not told_to :write }
      block.after  { expect(file_class).was     told_to(:write).with("/temp_dir/spec.rb", the_spec) }
    }
  end

  it 'invokes rspec against the temp dir' do
    rspec = described_class.new(the_spec).with_dependencies(dir_class: dir_class, file_class: file_class, open3_class: open3_class)
    dir_class.will_mktmpdir true
    rspec.pass?
    expect(rspec.dir_class).was told_to(:mktmpdir).with('mountain_berry_fields_rspec') { |block|
      block.call_with '/temp_dir'
      block.before { expect(open3_class).was_not told_to :capture3 }
      block.after  { expect(open3_class).was     told_to :capture3 } # not testing string directly, will let cukes verify it comes out right
    }
  end

  it 'passes when rspec executes successfully' do
    open3_class = Mock::Open3.clone.exit_with_success!
    rspec = described_class.new(the_spec).with_dependencies(dir_class: dir_class, file_class: file_class, open3_class: open3_class)
    expect(rspec).to pass

    open3_class = Mock::Open3.clone.exit_with_failure!
    rspec = described_class.new(the_spec).with_dependencies(dir_class: dir_class, file_class: file_class, open3_class: open3_class)
    expect(rspec).to_not pass
  end

  it 'pulls its failure message from the JSON output of the results, showing the description, message, and backtrace without the temp dir' do
    temp_dir = 'some_temp_dir'
    open3_class.will_capture3 [%'{"full_description":"THE DESCRIPTION","message":"THE MESSAGE","backtrace":["#{temp_dir}/THE BACKTRACE"]}', '', Mock::Process::Status.new]
    rspec = described_class.new(the_spec).with_dependencies(dir_class: dir_class, file_class: file_class, open3_class: open3_class)
    rspec.pass?
    expect(dir_class).was told_to(:mktmpdir).with(anything) { |block| block.call_with temp_dir }
    expect(rspec.failure_message).to include 'THE DESCRIPTION'
    expect(rspec.failure_message).to include 'THE MESSAGE'
    expect(rspec.failure_message).to include 'THE BACKTRACE'
  end
end

