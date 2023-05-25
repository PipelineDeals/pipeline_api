# frozen_string_literal: true

require "rubygems"
require "vcr"
require "pipeline"

begin
  require "pry"
rescue LoadError
end

if ENV["TEST_REPORTER"] || ENV["CI"]
  require "simplecov"
  require "active_support/inflector"

  SimpleCov.start "rails" do
    enable_coverage :branch
    coverage_criterion :branch

    add_filter "/config/"
    add_filter "/spec/"
    add_filter "/test/"
    add_filter "/vendor/"
    add_filter "/db/"
    add_filter "/db_historical/"

    Dir["app/*"].each do |dir|
      add_group File.basename(dir).humanize, dir
    end

    minimum_coverage 0
    merge_timeout 3600
  end
end

VCR.configure do |c|
  c.cassette_library_dir = "./spec/cassettes"
  c.hook_into                :webmock
  c.default_cassette_options = { record: :new_episodes }
end

def cassette(append)
  "#{described_class}_#{append}"
end
