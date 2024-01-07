require 'selenium/webdriver'

emulations = {
  default: {},
  iphone: { device_name: 'iPhone 12 Pro' },
  android: { device_name: 'Pixel 5' },
  ipad: { device_name: 'iPad Air' },
}.freeze

headlesses = { headed: nil, headless: 'headless' }.freeze

headlesses.each do |headless_key, headless|
  emulations.each do |emulation_key, emulation|
    driver_url = ENV.fetch('EZE_SELENIUM_DRIVER_REMOTE_CHROME_URL', nil)

    next unless driver_url

    driver_name = :"eze_selenium_remote_chrome_#{headless_key}_#{emulation_key}"

    args = ['start-maximized']
    args << headless if headless

    ::Capybara.register_driver(driver_name) do |app|
      ::Capybara::Selenium::Driver.new(
        app,
        browser: :remote,
        url: driver_url,
        capabilities: ::Selenium::WebDriver::Options.chrome(
          args:,
          emulation:,
        )
      )
    end
  end
end

Capybara.default_driver = :eze_selenium_remote_chrome_headless_default
