# frozen_string_literal: true

class Pipeline::User < Pipeline::Resource
  def initialize(pipeline:, id: nil, attributes: nil)
    super
  end

  def authenticate(app_key:, email:, password:, mfa_code: nil)
    auth = _post("auth.json", query: { app_key: app_key }, body: { email_or_username: email, password: password, mfa_code: mfa_code })
    if auth["token"]
      pipeline.jwt = { token: auth["token"] }
    elsif auth["user"] && auth["user"]["api_key"]
      pipeline.api_key = auth["user"]["api_key"]
      pipeline.app_key = app_key
    end
    reload(auth["user"]["id"])
    self
  end

  def revoke_jwt
    #  Pipeline::Auth.delete(:revoke)
    _delete("auth/revoke.json")
    pipeline.jwt = nil
  end

  def renew_jwt
    auth = _put("auth/renew.json")
    if auth["token"]
      pipeline.jwt = { token: auth["token"] }
    end
    reload
    self
  end
end
