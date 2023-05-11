# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Auth do
  it "authenticates a user with jwt token" do
    VCR.use_cassette(:auth_jwt_success) do
      a = described_class.authenticate("x@gmail.com", "abc123$$$$", nil, app_key: "010a14be40ff5deafb7de7e773b8bff0")
      expect(a.id).to eq(451)
    end
  end

  it "authenticates a user with jwt token" do
    VCR.use_cassette(:auth_api_key_success) do
      a = described_class.authenticate("x@gmail.com", "abc123$$$$", nil, app_key: "8ddaff5a21fd18070be60623e5074781")
      expect(a.id).to eq(451)
    end
  end

  it "fails authentication" do
    VCR.use_cassette(:auth_failure) do
      expect do
        a = described_class.authenticate("x@gmail.com", "xabc123$$$$", nil, app_key: "010a14be40ff5deafb7de7e773b8bff0")
      end.to raise_error ActiveResource::ForbiddenAccess
    end
  end
end
