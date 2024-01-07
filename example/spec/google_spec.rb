RSpec.describe "Google / " do
  using_driver :selenium_chrome

  it "Search keyword with Google" do
    step "Open google.com" do
      visit("https://google.com/")
    end

    form = nil

    step "Input keyword in search box" do
      form = fill_in('q', with: 'test')
    end

    step "Send return key" do
      form.send_keys(:return)

      expect(page).to have_title('test')
    end
  end
end
