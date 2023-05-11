module Pipeline
  class Auth < Pipeline::Resource
    include ActiveResource::Singleton

    def self.authenticate(email, password, mfa_code = nil, options = {})
      add_keys(options ||= {})
      options.merge!(email_or_username: email, password: password, mfa_code: mfa_code)
      self.include_root_in_json = false
      a = create(options)
      Pipeline.configure { |c| c.app_key = nil; c.auth_type = :bearer; c.bearer_token = a.token }
      self.include_root_in_json = true
      Pipeline::Account.account
    end
  end
end
