# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::CalendarEntryPriorities do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }

  # it_behaves_like "a paginated collection"

  it "creates a calendar_entry_priority" do
    VCR.use_cassette(:calendar_entry_priorities_create) do
      calendar_entry_priority = pipeline.calendar_entry_priorities.create(name: "test calendar entry priority", hex_color: 0)
      expect(calendar_entry_priority.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      calendar_entry_priority.destroy

      expect(pipeline.calendar_entry_priorities.all.count).to eq(0)
    end
  end

  it "lists calendar_entry_priorities" do
    VCR.use_cassette(:calendar_entry_priorities_index) do
      calendar_entry_priorities = pipeline.calendar_entry_priorities.all
      expect(calendar_entry_priorities.count).to eq(0)
    end
  end

  it "destroys a calendar_entry_priority" do
    VCR.use_cassette(:calendar_entry_priorities_delete) do
      calendar_entry_priority = pipeline.calendar_entry_priorities.create(name: "test calendar entry priority for deletion", hex_color: 0)
      calendar_entry_priority.destroy
      expect(pipeline.calendar_entry_priorities.all.map(&:id)).not_to include(calendar_entry_priority.id)
    end
  end
end
