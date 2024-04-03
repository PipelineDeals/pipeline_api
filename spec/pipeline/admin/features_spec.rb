# frozen_string_literal: true

require "spec_helper"

describe Pipeline::Admin::Feature do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1OTBmZjZkMjYwMmJiZTZhMWM2Y2MxZDY1ZDAxNjBkYyIsImp0aSI6ImQyYjM4OWYwLWNhYWYtMDEzYy1jNTU0LTJjZGU0ODAwMTEyMiIsImV4cCI6MTc0MjY3MTUxMH0.NgNTIAf216IIKItSJmVqRkAgiYD1JRuQfrEkX9alPeU" }) }

  it "shows a feature providers" do
    VCR.use_cassette(:features_find) do
      feature = pipeline.features.find(:sms_support)
      expect(feature.id).to eq("sms_support")
    end
  end

  it "adds a feature with a provider" do
    VCR.use_cassette(:features_add_provider) do
      feature = pipeline.features.find(:sms_support)
      result = feature.add_provider("JustCall", { this: :that })
      expect(result["id"]).to eq("sms_support")
      expect(result["providers"][0]).to match(hash_including("provided_by" => "JustCall", "data" => { "this" => "that" }))
      feature.remove_provider("JustCall")
    end
  end

  it "removes a provided feature" do
    VCR.use_cassette(:features_remove_provider) do
      feature = pipeline.features.find(:sms_support)
      feature.add_provider("JustCall", { this: :that })
      expect(feature.remove_provider("JustCall")).to eq("id" => "sms_support", "providers" => nil)
    end
  end
end
