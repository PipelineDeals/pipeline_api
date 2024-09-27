# frozen_string_literal: true

class Pipeline::Import < Pipeline::Resource
  def initialize(pipeline:, id: nil, attributes: nil)
    super
  end

  def start
    _post("imports/#{id}/start")
  end
end
