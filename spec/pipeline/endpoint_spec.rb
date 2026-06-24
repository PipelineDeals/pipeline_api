# frozen_string_literal: true

require "spec_helper"
require "webmock/rspec"

describe Pipeline::Endpoint do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "jwt-token" }) }

  it "GETs a path outside the /api/v3 prefix, authenticated, and returns the parsed body" do
    stub = stub_request(:get, "http://pld.com/api/internal/phone_lookup")
      .with(query: { "phone" => "+15551234567" }, headers: { "Authorization" => "Bearer jwt-token" })
      .to_return(status: 200, body: { "people" => [{ "id" => 1 }] }.to_json, headers: { "Content-Type" => "application/json" })

    result = pipeline.get("/api/internal/phone_lookup", query: { phone: "+15551234567" })

    expect(result["people"].first["id"]).to eq(1)
    expect(stub).to have_been_requested
  end

  it "authenticates with key params when there is no jwt" do
    pipeline = Pipeline.new(url: "http://pld.com", app_key: "app-key", account_key: "account-key")
    stub = stub_request(:get, "http://pld.com/api/internal/phone_lookup")
      .with(query: { "app_key" => "app-key", "account_key" => "account-key" })
      .to_return(status: 200, body: { "companies" => [] }.to_json)

    pipeline.get("/api/internal/phone_lookup")

    expect(stub).to have_been_requested
  end

  it "raises on a non-success response" do
    stub_request(:get, "http://pld.com/api/internal/phone_lookup").to_return(status: 401, body: { "error" => "nope" }.to_json)

    expect { pipeline.get("/api/internal/phone_lookup") }.to raise_error(Pipeline::Exceptions::NotAuthorizedError)
  end
end
