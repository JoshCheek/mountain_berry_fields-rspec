require 'rspec/core'
class MyFormatter
  attr_accessor :failed_examples

  def initialize
    self.failed_examples = []
  end

  def example_failed(example)
    failed_examples << example
  end
end

class MountainBerryFields
  class Test
    class RSpec
      Deject self
      dependency(:syntax_checker_class) { RubySyntaxChecker }

      def syntax_checker
        @syntax_checker ||= syntax_checker_class.new code_to_test
      end

      Strategy.register :rspec, self

      include Strategy

      def example_group
        code = code_to_test()
        Class.new(::RSpec::Core::ExampleGroup) { binding.eval code, '/spec.rb' }
      end

      def pass?
        @passed ||= syntax_checker.valid? && begin
          config = ::RSpec::Core::Configuration.new
          config.expose_dsl_globally = false
          config.files_to_run  = []

          observer = MyFormatter.new
          reporter = ::RSpec::Core::Reporter.new(config)
          reporter.register_listener observer, :example_failed
          example_group.run(reporter)
          @failed_example = observer.failed_examples.first
          !@failed_example
        end
      end

      def syntax_error_message
        return if syntax_checker.valid?
        syntax_checker.invalid_message
      end

      def failure_message
        syntax_error_message ||
          "#{spec_failure_description.chomp}:\n"      \
          "  #{spec_failure_message.chomp}\n"         \
          "\n"                                        \
          "backtrace:\n"                              \
          "  #{spec_failure_backtrace.join "\n  "}\n"
      end

      private

      def spec_failure_description
        @failed_example.description
      end

      def spec_failure_message
        @failed_example.exception.message
      end

      def spec_failure_backtrace
        ::RSpec::Core::BacktraceFormatter.new.format_backtrace(@failed_example.exception.backtrace)
      end
    end
  end
end
