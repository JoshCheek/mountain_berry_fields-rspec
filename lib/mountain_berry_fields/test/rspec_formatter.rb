require 'rspec/core/formatters/base_formatter'
require 'json'

class MountainBerryFields
  class Test
    class RSpec
      class Formatter < ::RSpec::Core::Formatters::BaseFormatter
        ::RSpec::Core::Formatters.register self, :example_failed
        def example_failed(example)
          print JSON.dump 'full_description' => example.description,
                          'message'          => example.exception.message,
                          'backtrace'        => ::RSpec::Core::BacktraceFormatter.new.format_backtrace(example.exception.backtrace)
        end
      end
    end
  end
end
