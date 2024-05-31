# frozen_string_literal: true

require "httparty"
require "active_support/all"
require "pipeline/exceptions"

class Pipeline::Base
  attr_reader :pipeline, :collection_name, :admin, :module_name

  def initialize(pipeline:)
    @pipeline = pipeline
    @collection_name = self.class.name.sub(/.*::/, "").underscore.pluralize
    @admin = self.class.name.include?("::Admin::") ? "/admin" : ""
    @module_name = self.class.name.sub(/::#{collection_name.singularize.camelize}$/, "").sub(/::#{collection_name.camelize}$/, "")
  end

  def _post(endpoint, query: {}, body: {}, headers: {})
    handle_errors(HTTParty.post(full_endpoint(endpoint), query: query.merge(common_query), body: body.to_json, headers: headers.merge(common_headers)))
  end

  def _get(endpoint, query: {}, headers: {})
    handle_errors(HTTParty.get(full_endpoint(endpoint), query: query.merge(common_query), headers: headers.merge(common_headers)))
  end

  def _put(endpoint, query: {}, body: {}, headers: {})
    handle_errors(HTTParty.put(full_endpoint(endpoint), query: query.merge(common_query), body: body.to_json, headers: headers.merge(common_headers)))
  end

  def _patch(endpoint, query: {}, body: {}, headers: {})
    handle_errors(HTTParty.patch(full_endpoint(endpoint), query: query.merge(common_query), body: body.to_json, headers: headers.merge(common_headers)))
  end

  def _delete(endpoint, query: {}, headers: {})
    handle_errors(HTTParty.delete(full_endpoint(endpoint), query: query.merge(common_query), headers: headers.merge(common_headers)))
  end

  def full_endpoint(endpoint)
    "#{pipeline.url}#{pipeline.prefix}#{admin}/#{endpoint}"
  end

  def common_query
    common_query = {}
    if pipeline.jwt.try(:fetch, :token, nil).blank?
      common_query.merge!(api_key: pipeline.api_key) if pipeline.api_key
      common_query.merge!(app_key: pipeline.app_key) if pipeline.app_key
      common_query.merge!(account_key: pipeline.account_key) if pipeline.account_key && !pipeline.api_key
    end
    common_query
  end

  def common_headers
    common_headers = { "Content-Type": "application/json" }
    common_headers.merge!(Authorization: "Bearer #{pipeline.jwt[:token]}") if pipeline.jwt.try(:fetch, :token, nil)
    common_headers
  end

  def handle_errors(response)
    if response.code != 200 && response.code != 204
      message = "#{response.code} #{(response.parsed_response.is_a?(Hash) && response.parsed_response["error"]) || "Error"}"
      raise Pipeline::Exceptions::BadRequestError.new(message) if response.code == 400
      raise Pipeline::Exceptions::NotAuthorizedError.new(message) if response.code == 401
      raise Pipeline::Exceptions::PermissionDeniedError.new(message) if response.code == 403
      raise Pipeline::Exceptions::NotFoundError.new(message) if response.code == 404
      raise Pipeline::Exceptions::NotAcceptableError.new(message) if response.code == 406
      raise Pipeline::Exceptions::TooManyRequestsError.new(message) if response.code == 429
      raise Pipeline::Exceptions::InternalPipelineError.new(message) if response.code == 500

      raise Pipeline::Exceptions::ApiError.new(message, response.code)
    end
    response.parsed_response
  end
end

require "pipeline/resource"
require "pipeline/collection"
