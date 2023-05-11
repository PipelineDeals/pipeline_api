module Pipeline
  class Auth < Pipeline::Resource
    include ActiveResource::Singleton

    def self.authenticate(email, password, mfa_code = nil, options = {})
      add_keys(options)
      options.merge!(email_or_username: email, password: password, mfa_code: mfa_code)

      self.include_root_in_json = false
      auth = create(options)
      self.include_root_in_json = true

      if auth.respond_to?(:token)
        configure_jwt_token(auth)
        Pipeline::User.find(auth.user.id)
      else
        configure_api_key(auth)
        # This path does not return the user within a hash, so the user id is at the top level.
        # It turns out that if the return hash only has one key, then it always assumes it is a "root" and removes
        # that level:
        # https://github.com/rails/activeresource/blob/main/lib/active_resource/base.rb#L1477-L1479
        Pipeline::User.find(auth.id)
      end
    end

    private

    def self.configure_api_key(auth)
      Pipeline.configure { |c| c.api_key = auth.api_key }
    end

    def self.configure_jwt_token(auth)
      Pipeline.configure { |c| c.app_key = nil; c.auth_type = :bearer; c.bearer_token = auth.token }
    end
  end
end
