require 'rspec/core'
require 'rspec/core/formatters/base_formatter'
require 'json'

# require '/Users/josh/code/mountain_berry_fields-rspec/lib/mountain_berry_fields/test/rspec_formatter.rb'  # => true
#
# config = RSpec::Core::Configuration.new                             # => #<RSpec::Core::Configuration:0x007fc4daa328d8 @start_time=2014-08-16 15:57:05 -0600, @expectation_frameworks=[], @include_or_extend_modules=[], @mock_framework=nil, @files_or_directories_to_run=[], @color=false, @pattern="**/*_spec.rb", @failure_exit_code=1, @spec_files_loaded=false, @backtrace_formatter=#<RSpec::Core::BacktraceFormatter:0x007fc4daa32630 @full_backtrace=false, @system_excl...
# config.expose_dsl_globally = false                                  # => false
# config.error_stream  = $stderr                                      # => #<IO:<STDERR>>
# config.output_stream = $stdout                                      # => #<IO:<STDOUT>>
# config.files_to_run  = []                                           # => []
# config.add_formatter 'MountainBerryFields::Test::RSpec::Formatter'  # => #<MountainBerryFields::Test::RSpec::Formatter:0x007fc4da973e60 @output=#<IO:<STDOUT>>, @example_group=nil>
#
#
# Class.new RSpec::Core::ExampleGroup do |*x|  # => Class
#   describe 'something' do
#     it 'does whatevz' do
#       expect(1).to eq 2
#     end                                      # => #<RSpec::Core::Example:0x007fc4da9d2640 @example_group_class=#<Class:0x007fc4da9702d8>, @example_block=#<Proc:0x007fc4da9d2780@/var/folders/7g/mbft22555w3_2nqs_h1kbglw0000gn/T/seeing_is_believing_temp_dir20140816-19539-sgkmns/program.rb:13>, @metadata={:execution_result=>#<RSpec::Core::Example::ExecutionResult:0x007fc4da9d21b8>, :block=>#<Proc:0x007fc4da9d2780@/var/folders/7g/mbft22555w3_2...
#   end                                        # => #<Class:0x007fc4da9702d8>
#   run(config.reporter)                       # => false
# end                                          # => #<Class:0x007fc4da970cd8>
#
# # >> {"full_description":"something does whatevz","message":"undefined method `fetch' for nil:NilClass","backtrace":[".var/folders/7g/mbft22555w3_2nqs_h1kbglw0000gn/T/seeing_is_believing_temp_dir20140816-19539-sgkmns/program.rb:17:in `block in <main>'",".var/folders/7g/mbft22555w3_2nqs_h1kbglw0000gn/T/seeing_is_believing_temp_dir20140816-19539-sgkmns/program.rb:11:in `initialize'",".var/folders...


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
