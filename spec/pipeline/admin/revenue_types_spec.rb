# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::RevenueTypes do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }

  # it_behaves_like "a paginated collection"

  it "creates a revenue_type" do
    VCR.use_cassette(:revenue_types_create) do
      revenue_type = pipeline.revenue_types.create(name: "test revenue type", position: 1)
      expect(revenue_type.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      revenue_type.destroy

      expect(pipeline.revenue_types.all.count).to eq(0)
    end
  end

  it "lists revenue_types" do
    VCR.use_cassette(:revenue_types_index) do
      revenue_types = pipeline.revenue_types.all
      expect(revenue_types.count).to eq(0)
    end
  end

  it "destroys a revenue_type" do
    VCR.use_cassette(:revenue_types_delete) do
      revenue_type = pipeline.revenue_types.create(name: "test revenue type for deletion", position: 1)
      revenue_type.destroy
      expect(pipeline.revenue_types.all.map(&:id)).not_to include(revenue_type.id)
    end
  end
end
