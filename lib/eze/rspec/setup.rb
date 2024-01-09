require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'

::Capybara.save_path ||= './tmp/eze/screenshots'

::RSpec.configure do |config|
  config.include ::Capybara::DSL

  config.include ::Eze::RSpec::DSL

  config.around do |example|
    @eze_run_context = ::Eze::RSpec::RunContext.current.add_example(example).last

    example.run
  end

  config.prepend_after(:each) do
    page.reset!
    page.driver.quit
  end
end
