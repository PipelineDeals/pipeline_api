# frozen_string_literal: true

require "spec_helper"

describe Pipeline::AccountNotification do
  it_behaves_like "a paginated collection"

  it "creates a notification" do
    VCR.use_cassette(:create_notification) do
      notification = described_class.create(text: "Testing Notification")
      expect(notification.id).not_to be_nil
    end
  end

  it "lists notifications" do
    VCR.use_cassette(:index_notifications) do
      notifications = described_class.all
      expect(notifications.size).to eq(9)
    end
  end
end
