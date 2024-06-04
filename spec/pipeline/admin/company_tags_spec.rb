# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::CompanyTags do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }

  # it_behaves_like "a paginated collection"

  it "creates a company_tag" do
    VCR.use_cassette(:company_tags_create) do
      company_tag = pipeline.company_tags.create(name: "test company tag")
      expect(company_tag.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      company_tag.destroy

      expect(pipeline.company_tags.all.count).to eq(0)
    end
  end

  it "lists company_tags" do
    VCR.use_cassette(:company_tags_index) do
      company_tags = pipeline.company_tags.all
      expect(company_tags.count).to eq(0)
    end
  end

  it "destroys a company_tag" do
    VCR.use_cassette(:company_tags_delete) do
      company_tag = pipeline.company_tags.create(name: "test company tag for deletion")
      company_tag.destroy
      expect(pipeline.company_tags.all.map(&:id)).not_to include(company_tag.id)
    end
  end
end
