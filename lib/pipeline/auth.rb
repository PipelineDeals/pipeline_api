# frozen_string_literal: true

class Pipeline::Auth < Pipeline::Resource
  attr_reader :hash, :before, :changes, :_id

  def initialize(pipeline:)
    super
    @collection_name = "auth"
  end

  def authenticate(app_key, email, password, mfa_code = nil)
    auth = _post("#{collection_name}.json", query: { app_key: app_key }, body: { email_or_username: email, password: password, mfa_code: mfa_code })
    if auth["token"]
      pipeline.jwt = { token: auth["token"] }
      Pipeline::User.new(pipeline: pipeline, id: auth["user"]["id"])
    elsif auth["api_key"]
      pipeline.api_key = auth["api_key"]
      pipeline.app_key = app_key
      Pipeline::User.new(pipeline: pipeline, id: auth["id"])
    end
  end

  def revoke_jwt
#  Pipeline::Auth.delete(:revoke)
  end
end
