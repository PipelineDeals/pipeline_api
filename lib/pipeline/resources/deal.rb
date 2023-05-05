# frozen_string_literal: true

module Pipeline
  class Deal < Pipeline::Resource
    has_many :people, class_name: "Pipeline::Person"
    has_many :documents, class_name: "Pipeline::Document"
    has_many :notes, class_name: "Pipeline::Note"
    has_many :calendar_entries, class_name: "Pipeline::CalendarEntry"
    belongs_to :primary_contact, class_name: "Pipeline::Person"
    belongs_to :company, class_name: "Pipeline::Company"
    belongs_to :user, class_name: "Pipeline::User"
    belongs_to :deal_stage, class_name: "Pipeline::DealStage"
    belongs_to :source, class_name: "Pipeline::LeadSource"
  end
end
