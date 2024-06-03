# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::NoteCategories do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }

  # it_behaves_like "a paginated collection"

  it "creates a note_category" do
    VCR.use_cassette(:note_categories_create) do
      note_category = pipeline.note_categories.create(name: "test note category")
      expect(note_category.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      note_category.destroy

      expect(pipeline.note_categories.all.count).to eq(0)
    end
  end

  it "lists note_categories" do
    VCR.use_cassette(:note_categories_index) do
      note_categories = pipeline.note_categories.all
      expect(note_categories.count).to eq(0)
    end
  end

  it "destroys a note_category" do
    VCR.use_cassette(:note_categories_delete) do
      note_category = pipeline.note_categories.create(name: "test note category for deletion")
      note_category.destroy
      expect(pipeline.note_categories.all.map(&:id)).not_to include(note_category.id)
    end
  end
end
