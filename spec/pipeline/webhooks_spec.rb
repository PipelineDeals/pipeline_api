# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Webhook do
  before { Pipeline.configure { |c| c.app_key = "010a14be40ff5deafb7de7e773b8bff0" } }

  after { Pipeline.configure { |c| c.app_key = nil } }

  # it_behaves_like "a paginated collection"

  it "creates a webhook" do
    VCR.use_cassette(:webhooks_create) do
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
      webhooks.map(&:destroy)
    end
  end

  it "lists webhooks" do
    VCR.use_cassette(:webhooks_index) do
      webhooks = described_class.all
      expect(webhooks.size).to eq(9)
    end
  end

  it "deletes a webhook" do
    VCR.use_cassette(:webhooks_delete) do
      webhook = described_class.create(event_model: "company", event_action: "destroy", failure_email: "test@test.com", url: "http://this.pld.com")
      Pipeline::Webhook.delete(webhook.id)
      expect(webhook.exists?).to be_falsey
      webhooks = described_class.all
    end
  end


  it "destroys a webhook" do
    VCR.use_cassette(:webhooks_destroy) do
      webhook = described_class.create(event_model: "company", event_action: "destroy", failure_email: "test@test.com", url: "http://this.pld.com")
      webhook.destroy
      expect(webhook.exists?).to be_falsey
    end
  end
end
