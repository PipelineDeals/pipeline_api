# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Auth do
  before do
    Pipeline.configure do |c|
      c.site = "http://pld.com"
      c.api_key = nil
      c.app_key = app_key
      c.bearer_token = nil
      c.auth_type = nil
    end
  end

  after { reset_config }

  context "when jwt" do
    let(:app_key) { "010a14be40ff5deafb7de7e773b8bff0" }

    it "authenticates a user with jwt token" do
      VCR.use_cassette(:auth_jwt_success) do
        user = described_class.authenticate("x@gmail.com", "abc123$$$$", nil)
        expect(user.id).to eq(451)
        expect(Pipeline.configure.bearer_token).not_to be_nil
      end
    end

    it "fails authentication" do
      VCR.use_cassette(:auth_failure) do
        expect do
          described_class.authenticate("x@gmail.com", "xabc123$$$$", nil)
        end.to raise_error ActiveResource::ForbiddenAccess
      end
    end
  end

  context "when api_key" do
    let(:app_key) { "8ddaff5a21fd18070be60623e5074781" }

    it "authenticats a user with api_key" do
      VCR.use_cassette(:auth_api_key_success) do
        user = described_class.authenticate("x@gmail.com", "abc123$$$$", nil)
        expect(user.id).to eq(451)
        expect(Pipeline.configure.bearer_token).to be_nil
        expect(Pipeline.configure.api_key).not_to be_nil
      end
    end
  end
end
