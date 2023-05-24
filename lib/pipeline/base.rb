# frozen_string_literal: true

require "HTTParty"
require "active_support/all"

class Pipeline::Base
  attr_reader :pipeline, :collection_name

  def initialize(pipeline:)
    @pipeline = pipeline
    @collection_name = self.class.name.sub(/.*::/, "").underscore.pluralize
  end

  def _create(endpoint, query: {}, body: {}, headers: {})
    HTTParty.create(full_endpoint(endpoint), query: query.merge(common_query), body: body.to_json, headers: headers.merge(common_headers)).parsed_response
  end

  def _get(endpoint, query: {}, headers: {})
    HTTParty.get(full_endpoint(endpoint), query: query.merge(common_query), headers: headers.merge(common_headers)).parsed_response
  end

  def _put(endpoint, query: {}, body: {}, headers: {})
    HTTParty.put(full_endpoint(endpoint), query: query.merge(common_query), body: body.to_json, headers: headers.merge(common_headers)).parsed_response
  end

  def _patch(endpoint, query: {}, body: {}, headers: {})
    HTTParty.patch(full_endpoint(endpoint), query: query.merge(common_query), body: body.to_json, headers: headers.merge(common_headers)).parsed_response
  end

  def _post(endpoint, query: {}, body: {}, headers: {})
    HTTParty.post(full_endpoint(endpoint), query: query.merge(common_query), body: body.to_json, headers: headers.merge(common_headers)).parsed_response
  end

  def _destroy(endpoint, query: {}, headers: {})
    HTTParty.delete(full_endpoint(endpoint), query: query.merge(common_query), headers: headers.merge(common_headers)).parsed_response
  end

  def full_endpoint(endpoint)
    "#{pipeline.url}#{pipeline.prefix}/#{endpoint}"
  end

  def common_query
    return @common_query if @common_query

    @common_query = {}
    unless pipeline.jwt && pipeline.jwt[:token]
      @common_query.merge!(api_key: pipeline.api_key) if pipeline.api_key
      @common_query.merge!(app_key: pipeline.app_key) if pipeline.app_key
    end
    @common_query
  end

  def common_headers
    return @common_headers if @common_headers

    @common_headers = { "Content-Type": "application/json" }
    @common_headers.merge!(Authorization: "Bearer #{pipeline.jwt[:token]}") if pipeline.jwt && pipeline.jwt[:token]
    @common_headers
  end
end

require "pipeline/resource"
require "pipeline/collection"
