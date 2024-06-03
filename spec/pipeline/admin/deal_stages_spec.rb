# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::DealStages do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }
  let!(:account) do
    VCR.use_cassette(:account) do
      pipeline.account
    end
  end

  # it_behaves_like "a paginated collection"

  it "creates a deal_stage" do
    VCR.use_cassette(:deal_stages_create) do
      deal_stage = pipeline.deal_stages.create(name: "test deal stage", percent: 23, deal_pipeline_id: account.deal_pipelines.first["id"])
      expect(deal_stage.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      deal_stage.destroy

      expect(pipeline.deal_stages.all.count).to eq(2)
    end
  end

  it "lists deal_stages" do
    VCR.use_cassette(:deal_stages_index) do
      deal_stages = pipeline.deal_stages.all
      expect(deal_stages.count).to eq(2)
    end
  end

  it "destroys a deal_stage" do
    VCR.use_cassette(:deal_stages_delete) do
      deal_stage = pipeline.deal_stages.create(name: "test deal stage for deletion", percent: 23, deal_pipeline_id: account.deal_pipelines.first["id"])
      deal_stage.destroy
      expect(pipeline.deal_stages.all.map(&:id)).not_to include(deal_stage.id)
    end
  end
end
