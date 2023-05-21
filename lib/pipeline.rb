# frozen_string_literal: true

require "rubygems"
require "active_resource"
require "pipeline/collection"
require "pipeline/resource"
require "pipeline/resources/account"
require_relative "pipeline/resources"
require_relative "pipeline/version"
require_relative "pipeline/resources/definitions"

Dir["#{File.dirname(__FILE__)}/resources/*.rb"].sort.each do |file|
  p "requring #{file}"
  require file
end

module Pipeline
  class << self

    def site
      Pipeline::Resource.site
    end

    def site=(site)
      Pipeline::Resource.site = site
    end
  end

  def self.configure
    block_given? ? yield(Pipeline::Resource) : Pipeline::Resource
  end
end
