module Eze
  module RSpec
    class ExampleContext
      ExecutionResult = Data.define(:status, :started_at, :finished_at, :exception) do
        def time
          finished_at - started_at if finished_at
        end
      end

      Step = Data.define(:success, :description, :screenshot_path, :started_at, :finished_at) do
        def time
          finished_at - started_at
        end
      end

      def initialize(example:)
        @example = example
      end

      def add_step(success:, description:, screenshot_path:, started_at:, finished_at:)
        self.steps << Step.new(success:, description:, screenshot_path:, started_at:, finished_at:)
      end

      def steps
        @steps ||= []
      end

      def description
        @example.full_description
      end

      def execution_result
        execution_result = @example.execution_result

        return unless execution_result

        ExecutionResult.new(
          status: execution_result.status,
          started_at: execution_result.started_at,
          finished_at: execution_result.finished_at,
          exception: execution_result.exception,
        )
      end
    end
  end
end
