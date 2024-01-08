require 'fileutils'

module Eze
  module RSpec
    class RunReporter
      BACKTRACE_CLEANER = ActiveSupport::BacktraceCleaner.new
      BACKTRACE_CLEANER.add_filter   { |line| line.start_with?('/cmd') ? line.sub('/cmd', '.') : line } # strip the Rails.root prefix
      BACKTRACE_CLEANER.add_silencer { |line| /eze|bundle|rspec/.match?(line) } # skip any lines from puma or rubygems

      TEMPLATE_PATH = Eze.root.join('templates/index.html.erb')

      TEMPLATE_ASSETS_PATH = Eze.root.join('templates/assets')

      def report_result(run_context = Eze::RSpec::RunContext.current)
        output = './tmp/eze/report'

        FileUtils.rm_rf(output)

        FileUtils.mkdir_p("#{output}/screenshots")

        data = {
          examples: [],
          helper: ERB::Util,
        }

        examples = run_context.examples.map do |example|
          data[:examples] << {
            description: example.description,
          }

          if example.execution_result
            data[:examples][-1][:execution_result] = {
              status: example.execution_result.status,
              started_at: example.execution_result.started_at,
              finished_at: example.execution_result.finished_at,
              time: example.execution_result.time,
            }

            if example.execution_result.exception
              data[:examples][-1][:execution_result][:exception] = {
                class_name: example.execution_result.exception.class.name,
                message: example.execution_result.exception.message,
                backtrace: BACKTRACE_CLEANER.clean(example.execution_result.exception.backtrace || []).join("\n"),
              }
            end
          end

          data[:examples][-1][:steps] = example.steps.map {|step|
            screenshot_path = "./screenshots/#{File.basename(step.screenshot_path)}"

            FileUtils.copy_file(step.screenshot_path, "#{output}/#{screenshot_path}")

            {
              description: step.description,
              success: step.success,
              screenshot_path:,
              time: step.time,
            }
          }
        end

        erb = File.open(TEMPLATE_PATH, &:read)

        html = ERB.new(erb).result_with_hash(**data)

        File.write("#{output}/index.html", html)

        FileUtils.copy_entry(TEMPLATE_ASSETS_PATH, "#{output}/assets")

        "#{output}/index.html"
      end
    end
  end
end
