require 'bundler/setup'
require 'surrogate/rspec'
require 'mountain_berry_fields'
require 'mountain_berry_fields/test/rspec'

RSpec::Matchers.define :pass do
  match { |matcher| matcher.pass? }
end

module Mock
  class SyntaxChecker
    Surrogate.endow self
    define(:initialize) { |syntax| }
    define(:valid?) { true }
    define(:invalid_message) { "shit ain't valid" }
  end

  class Dir
    Surrogate.endow self do
      define(:chdir)    { |dir,    &block| block.call }
      define(:mktmpdir) { |prefix, &block| block.call }
    end
  end

  class File
    Surrogate.endow self do
      define(:exist?) { true }
      define(:write)  { true }
      define(:read)   { "file contents" }
    end
  end

  class Open3
    Surrogate.endow self do
      define(:capture3) { |invocation| ["stdout", "stderr", @exitstatus||Process::Status.new] }
    end


    def self.exit_with_failure!
      @exitstatus = Process::Status.new.will_have_success? false
      self
    end

    def self.exit_with_success!
      @exitstatus = Process::Status.new.will_have_success? true
      self
    end
  end

  module Process
    class Status
      Surrogate.endow self
      define(:success?) { true }
    end
  end
end

MountainBerryFields::Test::RSpec.override(:syntax_checker_class) { Mock::SyntaxChecker }
