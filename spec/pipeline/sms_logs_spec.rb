# frozen_string_literal: true

require "spec_helper"
require "webmock/rspec"

describe Pipeline::SmsLogs do
  let(:pipeline) { Pipeline.new(url: "http://pld.com", jwt: { token: "test_token" }) }

  describe "#new" do
    it "creates a new SmsLog instance" do
      sms_log = pipeline.sms_logs.new(status: "sent", direction: "outbound")
      expect(sms_log).to be_a(Pipeline::SmsLog)
      expect(sms_log.status).to eq("sent")
      expect(sms_log.direction).to eq("outbound")
    end
  end

  # The one thing this resource can get wrong is the endpoint its class name derives, so exercise
  # both server routes with stubbed responses — the generic Resource attribute code is already
  # covered elsewhere and would pass even if the path were wrong.
  describe "derived endpoints" do
    it "lists from /api/v3/sms_logs.json" do
      stub_request(:get, "http://pld.com/api/v3/sms_logs.json").with(query: hash_including({}))
        .to_return(status: 200,
                   body: { entries: [{ id: 1, status: "delivered", direction: "outbound" }], pagination: { pages: 1 } }.to_json,
                   headers: { "Content-Type" => "application/json" })

      expect(pipeline.sms_logs.all.map(&:id)).to eq([1])
    end

    it "finds from /api/v3/sms_logs/:id.json" do
      stub_request(:get, "http://pld.com/api/v3/sms_logs/1.json")
        .to_return(status: 200, body: { id: 1, status: "delivered", direction: "outbound" }.to_json,
                   headers: { "Content-Type" => "application/json" })

      expect(pipeline.sms_logs.find(1)).to be_a(Pipeline::SmsLog)
    end
  end

  describe Pipeline::SmsLog do
    # Fields the API actually returns — ApiV3::SmsLogPresenter omits message_sid (a Twilio
    # identifier, not the customer's), so a log read from /api/v3/sms_logs never carries one.
    it "can be instantiated with attributes" do
      sms_log = described_class.new(
        pipeline: pipeline,
        attributes: {
          "id" => 1,
          "body" => "on my way",
          "from_number" => "+14155550000",
          "status" => "delivered",
          "direction" => "outbound"
        }
      )

      expect(sms_log.id).to eq(1)
      expect(sms_log.body).to eq("on my way")
      expect(sms_log.from_number).to eq("+14155550000")
      expect(sms_log.status).to eq("delivered")
      expect(sms_log.direction).to eq("outbound")
    end

    it "tracks attribute changes from initial state" do
      sms_log = described_class.new(
        pipeline: pipeline,
        attributes: { "status" => "queued", "direction" => "outbound" }
      )

      # New resources track changes from nil
      expect(sms_log.changes).to include("status" => [nil, "queued"])
    end
  end
end
