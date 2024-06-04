# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::DocumentTags do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }

  # it_behaves_like "a paginated collection"

  it "creates a document_tag" do
    VCR.use_cassette(:document_tags_create) do
      document_tag = pipeline.document_tags.create(name: "test document tag")
      expect(document_tag.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      document_tag.destroy

      expect(pipeline.document_tags.all.count).to eq(0)
    end
  end

  it "lists document_tags" do
    VCR.use_cassette(:document_tags_index) do
      document_tags = pipeline.document_tags.all
      expect(document_tags.count).to eq(0)
    end
  end

  it "destroys a document_tag" do
    VCR.use_cassette(:document_tags_delete) do
      document_tag = pipeline.document_tags.create(name: "test document tag for deletion")
      document_tag.destroy
      expect(pipeline.document_tags.all.map(&:id)).not_to include(document_tag.id)
    end
  end
end
