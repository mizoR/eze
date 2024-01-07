module Eze
  module RSpec
    module DSL
      attr_reader :eze_run_context

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def using_driver(driver)
          around do |example|
            previous_driver = Capybara.current_driver

            Capybara.current_driver = driver

            example.run
          ensure
            Capybara.current_driver = previous_driver
          end
        end

        def using_wait_time(seconds)
          around do |example|
            using_wait_time(seconds) { example.run }
          end
        end
      end

      def step(description, &block)
        started_at = Time.now

        begin
          block.call
        rescue ::StandardError, ::RSpec::Expectations::ExpectationNotMetError => e
          eze_run_context.add_step(
            success: false,
            description:,
            screenshot_path: save_screenshot,
            started_at:,
            finished_at: Time.now,
          )

          raise
        else
          eze_run_context.add_step(
            success: true,
            description:,
            screenshot_path: save_screenshot,
            started_at:,
            finished_at: Time.now,
          )
        end
      end
    end
  end
end
