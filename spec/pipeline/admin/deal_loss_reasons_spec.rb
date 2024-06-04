# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::DealLossReasons do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }

  # it_behaves_like "a paginated collection"

  it "creates a deal_loss_reason" do
    VCR.use_cassette(:deal_loss_reasons_create) do
      deal_loss_reason = pipeline.deal_loss_reasons.create(name: "test deal loss reason")
      expect(deal_loss_reason.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      deal_loss_reason.destroy

      expect(pipeline.deal_loss_reasons.all.count).to eq(0)
    end
  end

  it "lists deal_loss_reasons" do
    VCR.use_cassette(:deal_loss_reasons_index) do
      deal_loss_reasons = pipeline.deal_loss_reasons.all
      expect(deal_loss_reasons.count).to eq(0)
    end
  end

  it "destroys a deal_loss_reason" do
    VCR.use_cassette(:deal_loss_reasons_delete) do
      deal_loss_reason = pipeline.deal_loss_reasons.create(name: "test deal loss reason for deletion")
      deal_loss_reason.destroy
      expect(pipeline.deal_loss_reasons.all.map(&:id)).not_to include(deal_loss_reason.id)
    end
  end
end
