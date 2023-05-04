module Pipeline
  class Account < Pipeline::Resource
    include ActiveResource::Singleton
    def self.account(options = {})
      add_keys(options[:params] ||= {})
      find(options)
    end
  end
end
