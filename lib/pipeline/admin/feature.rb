# frozen_string_literal: true

class Pipeline::Admin::Feature < Pipeline::Resource
  def initialize(pipeline:, id: nil, attributes: nil)
    super
  end

  def remove_provider(provider_key)
    _delete("features/#{id}", query: { provider_key: provider_key })
  end

  def add_provider(provided_by:, data:, provider_key: nil)
    body = { provided_by: provided_by, data: data }
    body[:provider_key] = provider_key if provider_key
    _put("features/#{id}", body: body)
  end
end
