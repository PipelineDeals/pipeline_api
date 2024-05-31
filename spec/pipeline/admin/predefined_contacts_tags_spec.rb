# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::PredefinedContactsTags do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }

  # it_behaves_like "a paginated collection"

  it "creates a predefined_contacts_tag" do
    VCR.use_cassette(:predefined_contacts_tags_create) do
      predefined_contacts_tag = pipeline.predefined_contacts_tags.create(name: "test person tag")
      expect(predefined_contacts_tag.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      predefined_contacts_tag.destroy

      expect(pipeline.predefined_contacts_tags.all.count).to eq(2)
    end
  end

  it "lists predefined_contacts_tags" do
    VCR.use_cassette(:predefined_contacts_tags_index) do
      predefined_contacts_tags = pipeline.predefined_contacts_tags.all
      expect(predefined_contacts_tags.count).to eq(2)
    end
  end

  it "destroys a predefined_contacts_tag" do
    VCR.use_cassette(:predefined_contacts_tags_delete) do
      predefined_contacts_tag = pipeline.predefined_contacts_tags.create(name: "test person tag for deletion")
      predefined_contacts_tag.destroy
      expect(pipeline.predefined_contacts_tags.all.map(&:id)).not_to include(predefined_contacts_tag.id)
    end
  end
end
