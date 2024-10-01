# frozen_string_literal: true

class Pipeline::Import < Pipeline::Resource
  def initialize(pipeline:, id: nil, attributes: nil)
    super
  end

  def start(import_ids_sequence: [])
    _post("imports/#{id}/start", body: { import_ids_sequence: })
  end
end
