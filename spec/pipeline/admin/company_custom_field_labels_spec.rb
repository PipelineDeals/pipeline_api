# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::CompanyCustomFieldLabels do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }

  # it_behaves_like "a paginated collection"

  it "creates a company_custom_field_label" do
    VCR.use_cassette(:company_custom_field_labels_create) do
      company_custom_field_label = pipeline.company_custom_field_labels.create(name: "test company custom field label", field_type: "text")
      expect(company_custom_field_label.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      company_custom_field_label.destroy

      expect(pipeline.company_custom_field_labels.all.count).to eq(0)
    end
  end

  it "lists company_custom_field_labels" do
    VCR.use_cassette(:company_custom_field_labels_index) do
      company_custom_field_labels = pipeline.company_custom_field_labels.all
      expect(company_custom_field_labels.count).to eq(0)
    end
  end

  it "destroys a company_custom_field_label" do
    VCR.use_cassette(:company_custom_field_labels_delete) do
      company_custom_field_label = pipeline.company_custom_field_labels.create(name: "test company custom field label for deletion", field_type: "text")
      company_custom_field_label.destroy
      expect(pipeline.company_custom_field_labels.all.map(&:id)).not_to include(company_custom_field_label.id)
    end
  end
end
