module Pipeline
  class Resource < ActiveResource::Base
    self.collection_parser = Pipeline::Collection
    self.include_root_in_json = true
    self.prefix = "/api/v3/"
    self.site = "https://api.pipelinecrm.com"

    def self.add_keys(hash)
      hash[:api_key] = Pipeline.api_key unless Pipeline.account_key
      hash[:account_key] = Pipeline.account_key if Pipeline.account_key

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
  end
end
