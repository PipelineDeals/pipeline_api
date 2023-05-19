# frozen_string_literal: true

module Pipeline
  class Auth < Pipeline::Resource
    include ActiveResource::Singleton

    self.collection_name = "auth"

    def self.authenticate(email, password, mfa_code = nil, options = {})
      add_keys(options)
      options.merge!(email_or_username: email, password: password, mfa_code: mfa_code)

      self.include_root_in_json = false
      auth = create(options)
      self.include_root_in_json = true

      user = if auth.respond_to?(:token)
               configure_jwt_token(auth)
             else
               configure_api_key(auth)
             end

      # The `user` returned from the auth is not actually a valid Pipeline::User object that functions as expected.
      # So, to return the authenticated user, we're doing an extra hit on the server.
      Pipeline::User.find(user.id)
    end

    def self.configure_api_key(auth, options = {})
      Pipeline.configure { |c| c.api_key = auth.api_key }
      add_keys(options)
      # This path does not return the user within a hash, so the user id is at the top level.
      # It turns out that if the return hash only has one key, then it always assumes it is a "root" and removes
      # that level:
      # https://github.com/rails/activeresource/blob/main/lib/active_resource/base.rb#L1477-L1479
      auth
    end

    def self.configure_jwt_token(auth, options = {})
      Pipeline.configure do |c|
        c.app_key = nil
        c.auth_type = :bearer
        c.bearer_token = auth.token
      end
      add_keys(options)
      auth.user if auth.respond_to?(:user)
    end
  end
end
