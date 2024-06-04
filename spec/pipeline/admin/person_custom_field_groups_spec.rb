# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::PersonCustomFieldGroups do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }

  # it_behaves_like "a paginated collection"

  it "creates a person_custom_field_group" do
    VCR.use_cassette(:person_custom_field_groups_create) do
      person_custom_field_group = pipeline.person_custom_field_groups.create(name: "test person tag")
      expect(person_custom_field_group.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      person_custom_field_group.destroy

      expect(pipeline.person_custom_field_groups.all.count).to eq(0)
    end
  end

  it "lists person_custom_field_groups" do
    VCR.use_cassette(:person_custom_field_groups_index) do
      person_custom_field_groups = pipeline.person_custom_field_groups.all
      expect(person_custom_field_groups.count).to eq(0)
    end
  end

  it "destroys a person_custom_field_group" do
    VCR.use_cassette(:person_custom_field_groups_delete) do
      person_custom_field_group = pipeline.person_custom_field_groups.create(name: "test person tag for deletion")
      person_custom_field_group.destroy
      expect(pipeline.person_custom_field_groups.all.map(&:id)).not_to include(person_custom_field_group.id)
    end
  end
end
