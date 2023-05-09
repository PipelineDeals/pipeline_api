# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Webhook do
  before { Pipeline.configure { |c| c.app_key = "010a14be40ff5deafb7de7e773b8bff0" } }

  after { Pipeline.configure { |c| c.app_key = nil } }

  # it_behaves_like "a paginated collection"

  it "creates a webhook" do
    VCR.use_cassette(:create_webhook) do
      webhooks = [
        described_class.create(event_model: "person", event_action: "create", failure_email: "test@test.com", url: "http://this.pld.com"),
        described_class.create(event_model: "person", event_action: "update", failure_email: "test@test.com", url: "http://this.pld.com"),
        described_class.create(event_model: "person", event_action: "destroy", failure_email: "test@test.com", url: "http://this.pld.com"),
        described_class.create(event_model: "deal", event_action: "create", failure_email: "test@test.com", url: "http://this.pld.com"),
        described_class.create(event_model: "deal", event_action: "update", failure_email: "test@test.com", url: "http://this.pld.com"),
        described_class.create(event_model: "deal", event_action: "destroy", failure_email: "test@test.com", url: "http://this.pld.com"),
        described_class.create(event_model: "company", event_action: "create", failure_email: "test@test.com", url: "http://this.pld.com"),
        described_class.create(event_model: "company", event_action: "update", failure_email: "test@test.com", url: "http://this.pld.com"),
        described_class.create(event_model: "company", event_action: "destroy", failure_email: "test@test.com", url: "http://this.pld.com")
      ]
      expect(webhooks.map(&:id).compact.count).to eq(9)
    end
  end

  it "lists webhooks" do
    VCR.use_cassette(:index_webhooks) do
      webhooks = described_class.all
      expect(webhooks.size).to eq(9)
    end
  end
end
