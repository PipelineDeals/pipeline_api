# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::TodoTemplateItems do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }
  let!(:todo_template) do
    VCR.use_cassette(:todo_template) do
      pipeline.todo_templates.create(name: "test todo tmeplate")
    end
  end
  let!(:account) do
    VCR.use_cassette(:account) do
      pipeline.account
    end
  end

  # it_behaves_like "a paginated collection"

  it "creates a todo_template_item" do
    VCR.use_cassette(:todo_template_items_create) do
      todo_template_item = pipeline.todo_template_items.create(description: "test todo template item", todo_template_id: todo_template.id, event_category_id: account.event_categories.first["id"])
      expect(todo_template_item.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      todo_template_item.destroy

      expect(pipeline.todo_template_items.all.count).to eq(1)
    end
  end

  it "lists todo_template_items" do
    VCR.use_cassette(:todo_template_items_index) do
      todo_template_items = pipeline.todo_template_items.all
      expect(todo_template_items.count).to eq(1)
    end
  end

  it "destroys a todo_template_item" do
    VCR.use_cassette(:todo_template_items_delete) do
      todo_template_item = pipeline.todo_template_items.create(description: "test todo template item for deletion", todo_template_id: todo_template.id, event_category_id: account.event_categories.first["id"])
      todo_template_item.destroy
      expect(pipeline.todo_template_items.all.map(&:id)).not_to include(todo_template_item.id)
    end
  end
end
