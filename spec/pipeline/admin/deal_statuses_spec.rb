# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::DealStatuses do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }

  # it_behaves_like "a paginated collection"

  it "creates a deal_status" do
    VCR.use_cassette(:deal_statuses_create) do
      deal_status = pipeline.deal_statuses.create(name: "test deal status", hex_color: 0)
      expect(deal_status.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      deal_status.destroy

      expect(pipeline.deal_statuses.all.count).to eq(0)
    end
  end

  it "lists deal_statuses" do
    VCR.use_cassette(:deal_statuses_index) do
      deal_statuses = pipeline.deal_statuses.all
      expect(deal_statuses.count).to eq(0)
    end
  end

  it "destroys a deal_status" do
    VCR.use_cassette(:deal_statuses_delete) do
      deal_status = pipeline.deal_statuses.create(name: "test deal status for deletion", hex_color: 0)
      deal_status.destroy
      expect(pipeline.deal_statuses.all.map(&:id)).not_to include(deal_status.id)
    end
  end
end
