# frozen_string_literal: true

require "rubygems"
require "vcr"
require "pipeline"

begin
  require "pry"
rescue LoadError
end

#require "support/pagination_spec"
#require "support/has_documents"
#require "support/has_notes"
#require "support/has_calendar_entries"
#require "support/has_people"
#require "support/has_deals"

#def reset_config
#  Pipeline.configure do |c|
#    c.site = ENV["PIPELINEDEALS_URL"] || "http://localhost:3000"
#    c.api_key = ENV["PIPELINEDEALS_API_KEY"] || "iJHyFkMUBSfjUovt29"
#    c.app_key = nil
#    c.auth_type = nil
#    c.bearer_token = nil
#  end
#end
#
#reset_config

# ActiveResource::Base.logger = Logger.new(STDOUT)

VCR.configure do |c|
  c.cassette_library_dir = "./spec/cassettes"
  c.hook_into                :webmock
  c.default_cassette_options = { record: :new_episodes }
end

def cassette(append)
  "#{described_class}_#{append}"
end
