# frozen_string_literal: true

class Pipeline::Admin::Feature < Pipeline::Resource
  def initialize(pipeline:, id: nil, attributes: nil)
    super
  end

  def remove_provider(provided_by)
    _delete("features/#{id}", query: { provided_by: })
  end

  def add_provider(provided_by, data)
    _put("features/#{id}", body: { provided_by:, data: })
  end
end
