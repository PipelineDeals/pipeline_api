# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Auth do
  it "authenticates a user" do
    VCR.use_cassette(:auth_success) do
      a = described_class.authenticate("x@gmail.com", "abc123$$$$", nil, app_key: "010a14be40ff5deafb7de7e773b8bff0")
      expect(a.id).to eq(65)
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
