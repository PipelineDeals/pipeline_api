module Pipeline
  class Resource < ActiveResource::Base
    self.collection_parser = Pipeline::Collection
    self.include_root_in_json = true
    self.prefix = "/api/v3/"
    self.site = "https://api.pipelinecrm.com"

    def self.add_keys(hash)
      hash[:api_key] = Pipeline.api_key if !Pipeline.account_key && Pipeline.api_key
      hash[:account_key] = Pipeline.account_key if Pipeline.account_key
      self.auth_type = Pipeline.auth_type if Pipeline.auth_type
      self.bearer_token = Pipeline.bearer_token if Pipeline.bearer_token

      hash[:app_key] = Pipeline.app_key if Pipeline.app_key
      hash[:app_version] = Pipeline.app_version if Pipeline.app_version
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

    def exists?
      Pipeline::Resource.add_keys(prefix_options)

      super
    end

    def destroy
      Pipeline::Resource.add_keys(prefix_options)

      super
    end

    def self.exists?(id, options = {})
      add_keys(options)

      super(id, options)
    end

    def self.delete(id, options = {})
      add_keys(options)

      super(id, options)
    end
  end
end
