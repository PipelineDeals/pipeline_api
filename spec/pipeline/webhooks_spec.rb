# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::Webhook do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwMTBhMTRiZTQwZmY1ZGVhZmI3ZGU3ZTc3M2I4YmZmMCIsImp0aSI6ImJmZmNlNzkwLWRjYWYtMDEzYi0wZmIxLTJjZGU0ODAwMTEyMiJ9.Yz_l8laGdXwhBQcb7ymODeh4ajH_K7p3FJIfcmLcpKA" }) }

  # it_behaves_like "a paginated collection"

  it "creates a webhook" do
    VCR.use_cassette(:webhooks_create) do
      webhooks = [
        pipeline.webhooks.create(event_model: "person", event_action: "create", failure_email: "test@test.com", url: "http://this.pld.com"),
        pipeline.webhooks.create(event_model: "person", event_action: "update", failure_email: "test@test.com", url: "http://this.pld.com"),
        pipeline.webhooks.create(event_model: "person", event_action: "destroy", failure_email: "test@test.com", url: "http://this.pld.com"),
        pipeline.webhooks.create(event_model: "deal", event_action: "create", failure_email: "test@test.com", url: "http://this.pld.com"),
        pipeline.webhooks.create(event_model: "deal", event_action: "update", failure_email: "test@test.com", url: "http://this.pld.com"),
        pipeline.webhooks.create(event_model: "deal", event_action: "destroy", failure_email: "test@test.com", url: "http://this.pld.com"),
        pipeline.webhooks.create(event_model: "company", event_action: "create", failure_email: "test@test.com", url: "http://this.pld.com"),
        pipeline.webhooks.create(event_model: "company", event_action: "update", failure_email: "test@test.com", url: "http://this.pld.com"),
        pipeline.webhooks.create(event_model: "company", event_action: "destroy", failure_email: "test@test.com", url: "http://this.pld.com")
      ]
      expect(webhooks.map(&:id).compact.count).to eq(9)
      # Just wanted to leave thigns as they were before
      webhooks.map(&:destroy)
    end
  end

  it "lists webhooks" do
    VCR.use_cassette(:webhooks_index) do
      webhooks = pipeline.webhooks.all
      expect(webhooks.count).to eq(9)
    end
  end

  it "destroys a webhook" do
    VCR.use_cassette(:webhooks_delete) do
      webhook = pipeline.webhooks.create(event_model: "company", event_action: "destroy", failure_email: "test@test.com", url: "http://this.pld.com")
      webhook.destroy
      expect(pipeline.webhooks.all.map(&:id)).not_to include(webhook.id)
    end
  end
end
