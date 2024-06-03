# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::LeadStatuses do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }

  # it_behaves_like "a paginated collection"

  it "creates a lead_status" do
    VCR.use_cassette(:lead_statuses_create) do
      lead_status = pipeline.lead_statuses.create(name: "test lead status", hex_color: 0)
      expect(lead_status.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      lead_status.destroy

      expect(pipeline.lead_statuses.all.count).to eq(1)
    end
  end

  it "lists lead_statuses" do
    VCR.use_cassette(:lead_statuses_index) do
      lead_statuses = pipeline.lead_statuses.all
      expect(lead_statuses.count).to eq(1)
    end
  end

  it "destroys a lead_status" do
    VCR.use_cassette(:lead_statuses_delete) do
      lead_status = pipeline.lead_statuses.create(name: "test lead status for deletion", hex_color: 0)
      lead_status.destroy
      expect(pipeline.lead_statuses.all.map(&:id)).not_to include(lead_status.id)
    end
  end
end
