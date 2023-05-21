module Pipeline
  class Resource < ActiveResource::Base
    class << self
      include ThreadsafeAttributes
      threadsafe_attribute :account_key, :api_key, :app_key, :app_version, :bearer_token, :auth_type
    end

    self.collection_parser = Pipeline::Collection
    self.include_root_in_json = true
    self.prefix = "/api/v3/"
    self.site = "https://api.pipelinecrm.com"

    def self.add_keys(hash)
      hash[:api_key] = Pipeline::Resource.api_key if Pipeline::Resource.api_key && !Pipeline::Resource.account_key && !Pipeline::Resource.bearer_token
      hash[:account_key] = Pipeline::Resource.account_key if Pipeline::Resource.account_key

      hash[:app_key] = Pipeline::Resource.app_key if Pipeline::Resource.app_key
      hash[:app_version] = Pipeline::Resource.app_version if Pipeline::Resource.app_version
    end

    def self.find(*arguments)
      scope = arguments.slice!(0)
      options = arguments.slice!(0) || {}

      add_keys(options[:params] ||= {})

      super(scope, options)
    end

    def save
      Pipeline::Resource.add_keys(prefix_options)

      super
    end
  end
end
