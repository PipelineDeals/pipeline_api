# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::DealCustomFieldLabels do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }

  # it_behaves_like "a paginated collection"

  it "creates a deal_custom_field_label" do
    VCR.use_cassette(:deal_custom_field_labels_create) do
      deal_custom_field_label = pipeline.deal_custom_field_labels.create(name: "test deal custom field label", field_type: "text")
      expect(deal_custom_field_label.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      deal_custom_field_label.destroy

      expect(pipeline.deal_custom_field_labels.all.count).to eq(2)
    end
  end

  it "lists deal_custom_field_labels" do
    VCR.use_cassette(:deal_custom_field_labels_index) do
      deal_custom_field_labels = pipeline.deal_custom_field_labels.all
      expect(deal_custom_field_labels.count).to eq(2)
    end
  end

  it "destroys a deal_custom_field_label" do
    VCR.use_cassette(:deal_custom_field_labels_delete) do
      deal_custom_field_label = pipeline.deal_custom_field_labels.create(name: "test deal custom field label for deletion", field_type: "text")
      deal_custom_field_label.destroy
      expect(pipeline.deal_custom_field_labels.all.map(&:id)).not_to include(deal_custom_field_label.id)
    end
  end
end
