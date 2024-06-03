# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::DealCustomFieldGroups do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }

  # it_behaves_like "a paginated collection"

  it "creates a deal_custom_field_group" do
    VCR.use_cassette(:deal_custom_field_groups_create) do
      deal_custom_field_group = pipeline.deal_custom_field_groups.create(name: "test deal custom field group")
      expect(deal_custom_field_group.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      deal_custom_field_group.destroy

      expect(pipeline.deal_custom_field_groups.all.count).to eq(0)
    end
  end

  it "lists deal_custom_field_groups" do
    VCR.use_cassette(:deal_custom_field_groups_index) do
      deal_custom_field_groups = pipeline.deal_custom_field_groups.all
      expect(deal_custom_field_groups.count).to eq(0)
    end
  end

  it "destroys a deal_custom_field_group" do
    VCR.use_cassette(:deal_custom_field_groups_delete) do
      deal_custom_field_group = pipeline.deal_custom_field_groups.create(name: "test deal custom field group for deletion")
      deal_custom_field_group.destroy
      expect(pipeline.deal_custom_field_groups.all.map(&:id)).not_to include(deal_custom_field_group.id)
    end
  end
end
