# frozen_string_literal: true

require "spec_helper"
require "webmock/rspec"

describe Pipeline::Profile do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "jwt-token" }) }

  before do
    stub_request(:get, "http://pld.com/api/v3/profile.json")
      .to_return(status: 200, body: { "id" => 42, "work_phone" => nil }.to_json, headers: { "Content-Type" => "application/json" })
  end

  it "loads the current user from the singular profile.json endpoint" do
    expect(pipeline.profile.id).to eq(42)
  end

  it "saves only changed attributes back to profile.json under the :user key" do
    put_stub = stub_request(:put, "http://pld.com/api/v3/profile.json")
      .with(body: { user: { work_phone: "+15551234567" } }.to_json, headers: { "Authorization" => "Bearer jwt-token" })
      .to_return(status: 200, body: { "id" => 42, "work_phone" => "+15551234567" }.to_json, headers: { "Content-Type" => "application/json" })

    profile = pipeline.profile
    profile.work_phone = "+15551234567"
    profile.save

    expect(put_stub).to have_been_requested
    expect(profile.work_phone).to eq("+15551234567")
  end

  it "raises the mapped exception when the update is refused" do
    stub_request(:put, "http://pld.com/api/v3/profile.json").to_return(status: 403, body: { "error" => "nope" }.to_json)

    profile = pipeline.profile
    profile.work_phone = "+15551234567"
    expect { profile.save }.to raise_error(Pipeline::Exceptions::PermissionDeniedError)
  end
end
