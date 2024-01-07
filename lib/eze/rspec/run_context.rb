module Eze
  module RSpec
    class RunContext
      def self.current
        @current ||= new
      end

      attr_accessor :id

      def add_example(example)
        examples << ::Eze::RSpec::ExampleContext.new(example:)
      end

      def examples
        @examples ||= []
      end
    end
  end
end
