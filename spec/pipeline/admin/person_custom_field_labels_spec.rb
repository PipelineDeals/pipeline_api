# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::PersonCustomFieldLabels do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }

  # it_behaves_like "a paginated collection"

  it "creates a person_custom_field_label" do
    VCR.use_cassette(:person_custom_field_labels_create) do
      person_custom_field_label = pipeline.person_custom_field_labels.create(name: "test person custom field", field_type: "text")
      expect(person_custom_field_label.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      person_custom_field_label.destroy

      expect(pipeline.person_custom_field_labels.all.count).to eq(7)
    end
  end

  it "lists person_custom_field_labels" do
    VCR.use_cassette(:person_custom_field_labels_index) do
      person_custom_field_labels = pipeline.person_custom_field_labels.all
      expect(person_custom_field_labels.count).to eq(7)
    end
  end

  it "destroys a person_custom_field_label" do
    VCR.use_cassette(:person_custom_field_labels_delete) do
      person_custom_field_label = pipeline.person_custom_field_labels.create(name: "test person custom field for deletion", field_type: "text")
      person_custom_field_label.destroy
      expect(pipeline.person_custom_field_labels.all.map(&:id)).not_to include(person_custom_field_label.id)
    end
  end
end
