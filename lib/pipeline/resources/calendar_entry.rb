# frozen_string_literal: true

module Pipeline
  class CalendarEntry < Pipeline::Resource
    belongs_to :category, class_name: "Pipeline::EventCategory"
    belongs_to :owner, class_name: "Pipeline::User"
    belongs_to :company, class_name: "Pipeline::Company"
  end
end
