# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::CustomFieldLabelDropdownEntries do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }
  let!(:custom_field) do
    VCR.use_cassette(:deal_custom_field_labels) do
      pipeline.deal_custom_field_labels.create(name: "test dropdown field", field_type: "dropdown")
    end
  end

  # it_behaves_like "a paginated collection"

  it "creates a custom_field_label_dropdown_entry" do
    VCR.use_cassette(:custom_field_label_dropdown_entries_create) do
      custom_field_label_dropdown_entry = pipeline.custom_field_label_dropdown_entries.create(name: "test custom field dropdown entry",
                                                                                              custom_field_label_id: custom_field.id)
      expect(custom_field_label_dropdown_entry.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      custom_field_label_dropdown_entry.destroy

      expect(pipeline.custom_field_label_dropdown_entries.where(custom_field_label_id: custom_field.id).all.count).to eq(0)
    end
  end

  it "lists custom_field_label_dropdown_entries" do
    VCR.use_cassette(:custom_field_label_dropdown_entries_index) do
      custom_field_label_dropdown_entries = pipeline.custom_field_label_dropdown_entries.where(custom_field_label_id: custom_field.id).all
      expect(custom_field_label_dropdown_entries.count).to eq(0)
    end
  end

  it "destroys a custom_field_label_dropdown_entry" do
    VCR.use_cassette(:custom_field_label_dropdown_entries_delete) do
      custom_field_label_dropdown_entry = pipeline.custom_field_label_dropdown_entries.create(name: "test custom field dropdown entry for deletion",
                                                                                              custom_field_label_id: custom_field.id)
      custom_field_label_dropdown_entry.destroy
      expect(pipeline.custom_field_label_dropdown_entries.where(custom_field_label_id: custom_field.id).all.map(&:id)).not_to include(custom_field_label_dropdown_entry.id)
    end
  end
end
