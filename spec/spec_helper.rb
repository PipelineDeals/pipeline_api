# frozen_string_literal: true

require "rubygems"
require "vcr"
require "pipeline"
require "simplecov"

begin
  require "pry"
rescue LoadError
end

VCR.configure do |c|
  c.cassette_library_dir = "./spec/cassettes"
  c.hook_into                :webmock
  c.default_cassette_options = { record: :new_episodes }
end

def cassette(append)
  "#{described_class}_#{append}"
end
