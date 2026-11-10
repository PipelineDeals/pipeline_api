# frozen_string_literal: true

require "spec_helper"

describe Pipeline::SmsLogs do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "test_token" }) }

  describe "#new" do
    it "creates a new SmsLog instance" do
      sms_log = pipeline.sms_logs.new(message_sid: "SM_123", status: "sent")
      expect(sms_log).to be_a(Pipeline::SmsLog)
      expect(sms_log.message_sid).to eq("SM_123")
      expect(sms_log.status).to eq("sent")
    end
  end

  # NOTE: #find tests would need VCR cassettes recorded against a running API

  describe Pipeline::SmsLog do
    it "can be instantiated with attributes" do
      sms_log = described_class.new(
        pipeline: pipeline,
        attributes: {
          "id" => 1,
          "message_sid" => "SM_123",
          "status" => "delivered",
          "direction" => "outbound"
        }
      )

      expect(sms_log.id).to eq(1)
      expect(sms_log.message_sid).to eq("SM_123")
      expect(sms_log.status).to eq("delivered")
      expect(sms_log.direction).to eq("outbound")
    end

    it "tracks attribute changes from initial state" do
      sms_log = described_class.new(
        pipeline: pipeline,
        attributes: { "message_sid" => "SM_123", "status" => "queued" }
      )

      # New resources track changes from nil
      expect(sms_log.changes).to include("status" => [nil, "queued"])
    end
  end
end
