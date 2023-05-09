
require 'spec_helper'

describe Pipeline::AccountNotification do
  it_should_behave_like "a paginated collection"

  before do
    Pipeline.configure do |c|
      c.api_key = "OarV2UVz6e_VKBhWG9AL"
      c.app_key = "be475137b519a79c903492e2693dc9b9"
      c.site = "http://pld.com"
    end
  end

  let(:account) { VCR.use_cassette(:get_account) { Pipeline::Account.account } }

  it "creates a notification" do
    VCR.use_cassette(:create_notification) do
      notification = Pipeline::AccountNotification.create(text: "Testing Notification")
      expect(notification.id).not_to be_nil
    end
  end

  it "lists notifications" do
    VCR.use_cassette(:index_notifications) do
      notifications = account.notifications
      expect(notifications.size).to eq(9)
    end
  end
end
