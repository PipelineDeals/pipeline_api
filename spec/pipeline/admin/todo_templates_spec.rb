# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::TodoTemplates do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }

  # it_behaves_like "a paginated collection"

  it "creates a todo_template" do
    VCR.use_cassette(:todo_templates_create) do
      todo_template = pipeline.todo_templates.create(name: "test person tag")
      expect(todo_template.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      todo_template.destroy

      expect(pipeline.todo_templates.all.count).to eq(1)
    end
  end

  it "lists todo_templates" do
    VCR.use_cassette(:todo_templates_index) do
      todo_templates = pipeline.todo_templates.all
      expect(todo_templates.count).to eq(1)
    end
  end

  it "destroys a todo_template" do
    VCR.use_cassette(:todo_templates_delete) do
      todo_template = pipeline.todo_templates.create(name: "test person tag for deletion")
      todo_template.destroy
      expect(pipeline.todo_templates.all.map(&:id)).not_to include(todo_template.id)
    end
  end
end
