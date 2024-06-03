# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::LeadSources do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }

  # it_behaves_like "a paginated collection"

  it "creates a lead_source" do
    VCR.use_cassette(:lead_sources_create) do
      lead_source = pipeline.lead_sources.create(name: "test lead source")
      expect(lead_source.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      lead_source.destroy

      expect(pipeline.lead_sources.all.count).to eq(1)
    end
  end

  it "lists lead_sources" do
    VCR.use_cassette(:lead_sources_index) do
      lead_sources = pipeline.lead_sources.all
      expect(lead_sources.count).to eq(1)
    end
  end

  it "destroys a lead_source" do
    VCR.use_cassette(:lead_sources_delete) do
      lead_source = pipeline.lead_sources.create(name: "test lead source for deletion")
      lead_source.destroy
      expect(pipeline.lead_sources.all.map(&:id)).not_to include(lead_source.id)
    end
  end
end
