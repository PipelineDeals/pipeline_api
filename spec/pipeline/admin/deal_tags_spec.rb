# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::DealTags do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }

  # it_behaves_like "a paginated collection"

  it "creates a deal_tag" do
    VCR.use_cassette(:deal_tags_create) do
      deal_tag = pipeline.deal_tags.create(name: "test deal tag")
      expect(deal_tag.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      deal_tag.destroy

      expect(pipeline.deal_tags.all.count).to eq(0)
    end
  end

  it "lists deal_tags" do
    VCR.use_cassette(:deal_tags_index) do
      deal_tags = pipeline.deal_tags.all
      expect(deal_tags.count).to eq(0)
    end
  end

  it "destroys a deal_tag" do
    VCR.use_cassette(:deal_tags_delete) do
      deal_tag = pipeline.deal_tags.create(name: "test deal tag for deletion")
      deal_tag.destroy
      expect(pipeline.deal_tags.all.map(&:id)).not_to include(deal_tag.id)
    end
  end
end
