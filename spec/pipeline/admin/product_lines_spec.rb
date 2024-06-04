# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::ProductLines do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiM2JkYTBlMjFhMTc4ZjI5OGI3OWIzMTA5NDViMzI1OCIsImp0aSI6IjVhZjg3MDAwLTAxODMtMDEzZC00M2ZmLTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0ODY5OTcyMH0.wACkSpBq3A9aXxfIkXJ-Syovv8JrPgG5Pa6qlAZLrqQ" }) }

  # it_behaves_like "a paginated collection"

  it "creates a product_line" do
    VCR.use_cassette(:product_lines_create) do
      product_line = pipeline.product_lines.create(name: "test product_line")
      expect(product_line.id).not_to be_nil

      # Just wanted to leave thigns as they were before
      product_line.destroy

      expect(pipeline.product_lines.all.count).to eq(0)
    end
  end

  it "lists product_lines" do
    VCR.use_cassette(:product_lines_index) do
      product_lines = pipeline.product_lines.all
      expect(product_lines.count).to eq(0)
    end
  end

  it "destroys a product_line" do
    VCR.use_cassette(:product_lines_delete) do
      product_line = pipeline.product_lines.create(name: "test product_line for deletion")
      product_line.destroy
      expect(pipeline.product_lines.all.map(&:id)).not_to include(product_line.id)
    end
  end
end
