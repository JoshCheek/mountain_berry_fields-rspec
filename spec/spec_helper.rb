require 'bundler/setup'
require 'surrogate/rspec'
require 'mountain_berry_fields'
require 'mountain_berry_fields/autoloaded_strategies/rspec'

class RSpec::Expectations::ExpectationTarget
  alias was     to
  alias was_not not_to
end

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  config.disable_monkey_patching!
end

RSpec::Matchers.define :pass do
  match { |matcher| matcher.pass? }
end

require 'mountain_berry_fields/interface'
class MountainBerryFields
  module Interface
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
  MountainBerryFields::Test::RSpec.override(:syntax_checker_class) { Interface::SyntaxChecker }
end
