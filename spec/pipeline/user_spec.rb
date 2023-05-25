# frozen_string_literal: true

require "spec_helper"

describe Pipeline::User do
  let(:pipeline) { Pipeline.new(url: "http://pld.com") }
  let(:authenticate) { pipeline.authenticate(app_key: app_key, email: email, password: password, mfa_code: mfa_code) }
  let(:app_key) { "010a14be40ff5deafb7de7e773b8bff0" }
  let(:email) { "y@gmail.com" }
  let(:password) { "xyz987$$$$" }
  let(:mfa_code) { nil }

  context "with jwt app_key" do
    it "successfully authenticates" do
      VCR.use_cassette(:authenticate_with_jwt_success) do
        expect(authenticate.id).to eq(452)
      end
    end

    it "has jwt token" do
      VCR.use_cassette(:authenticate_with_jwt_token) do
        authenticate
        expect(pipeline.jwt).not_to be_nil
        expect(pipeline.app_key).to be_nil
        expect(pipeline.api_key).to be_nil
        expect(pipeline.people.all.count).to eq(15)
      end
    end
  end

  context "with api_key app_key" do
    let(:app_key) { "8ddaff5a21fd18070be60623e5074781" }

    it "successfully authenticates" do
      VCR.use_cassette(:authenticate_with_api_key_success) do
        expect(authenticate.id).to eq(452)
      end
    end

    it "has api_key and app_key" do
      VCR.use_cassette(:authenticate_with_api_key_token) do
        authenticate
        expect(pipeline.jwt).to be_nil
        #expect(pipeline.app_key).not_to be_nil
        #expect(pipeline.api_key).not_to be_nil
        expect(pipeline.people.all.count).to eq(15)
      end
    end
  end
end
