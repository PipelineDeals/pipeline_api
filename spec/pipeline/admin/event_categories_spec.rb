# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::EventCategories do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }

  # it_behaves_like "a paginated collection"

  it "creates a event_category" do
    VCR.use_cassette(:event_categories_create) do
      event_category = pipeline.event_categories.create(name: "test event category")
      expect(event_category.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      event_category.destroy

      expect(pipeline.event_categories.all.count).to eq(1)
    end
  end

  it "lists event_categories" do
    VCR.use_cassette(:event_categories_index) do
      event_categories = pipeline.event_categories.all
      expect(event_categories.count).to eq(1)
    end
  end

  it "destroys a event_category" do
    VCR.use_cassette(:event_categories_delete) do
      event_category = pipeline.event_categories.create(name: "test event category for deletion")
      event_category.destroy
      expect(pipeline.event_categories.all.map(&:id)).not_to include(event_category.id)
    end
  end
end
