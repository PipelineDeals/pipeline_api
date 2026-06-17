# frozen_string_literal: true

require "spec_helper"

describe Pipeline::CallLogs do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "test_token" }) }

  describe "#new" do
    it "creates a new CallLog instance" do
      call_log = pipeline.call_logs.new(conference_name: "conf_123", status: "ringing")
      expect(call_log).to be_a(Pipeline::CallLog)
      expect(call_log.conference_name).to eq("conf_123")
      expect(call_log.status).to eq("ringing")
    end
  end

  # NOTE: #find tests would need VCR cassettes recorded against a running API

  describe Pipeline::CallLog do
    it "can be instantiated with attributes" do
      call_log = described_class.new(
        pipeline: pipeline,
        attributes: {
          "id" => 1,
          "conference_name" => "conf_123",
          "status" => "in_progress",
          "direction" => "incoming"
        }
      )

      expect(call_log.id).to eq(1)
      expect(call_log.conference_name).to eq("conf_123")
      expect(call_log.status).to eq("in_progress")
      expect(call_log.direction).to eq("incoming")
    end

    it "tracks attribute changes from initial state" do
      call_log = described_class.new(
        pipeline: pipeline,
        attributes: { "conference_name" => "conf_123", "status" => "ringing" }
      )

      # New resources track changes from nil
      expect(call_log.changes).to include("status" => [nil, "ringing"])

      call_log.status = "completed"
      expect(call_log.changes).to include("status" => [nil, "completed"])
    end
  end

  describe "#recording_upload_url" do
    it "posts conference_name + mime to the recording_upload_url endpoint and returns the payload" do
      collection = pipeline.call_logs
      allow(collection).to receive(:_post)
        .with("call_logs/recording_upload_url.json",
              body: { call_log: { conference_name: "tele-1", recording_mime: "audio/mpeg" } })
        .and_return("recording_upload_url" => "https://s3/put", "file_key" => "k")

      result = collection.recording_upload_url(conference_name: "tele-1", recording_mime: "audio/mpeg")

      expect(result["recording_upload_url"]).to eq("https://s3/put")
    end
  end

  describe "#confirm_recording" do
    it "posts the conference_name to the confirm_recording endpoint" do
      collection = pipeline.call_logs
      allow(collection).to receive(:_post)
        .with("call_logs/confirm_recording.json", body: { call_log: { conference_name: "tele-1" } })
        .and_return("recording_status" => "captured")

      result = collection.confirm_recording(conference_name: "tele-1")

      expect(result["recording_status"]).to eq("captured")
    end
  end
end
