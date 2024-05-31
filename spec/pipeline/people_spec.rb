# frozen_string_literal: true

require "spec_helper"

describe Pipeline::People do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }

  # it_behaves_like "a paginated collection"

  it "creates a person" do
    VCR.use_cassette(:people_create) do
      person = pipeline.people.create(full_name: "test person")
      expect(person.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      person.destroy

      expect(pipeline.people.all.count).to eq(9)
    end
  end

  it "lists people" do
    VCR.use_cassette(:people_index) do
      people = pipeline.people.all
      expect(people.count).to eq(9)
    end
  end

  it "destroys a predefined_contacts_tag" do
    VCR.use_cassette(:people_delete) do
      person = pipeline.people.create(full_name: "test person")
      person.destroy
      expect(pipeline.people.all.map(&:id)).not_to include(person.id)
    end
  end
end
