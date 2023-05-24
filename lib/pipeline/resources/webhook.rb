# frozen_string_literal: true

module Pipeline
  class Webhook < Pipeline::AdminResource
    belongs_to :account, class_name: Pipeline::Account
  end
end
