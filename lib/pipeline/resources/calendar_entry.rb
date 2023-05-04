module Pipeline
  class CalendarEntry < Pipeline::Resource
    belongs_to :category, class_name: Pipeline::EventCategory, foreign_key: :category_id
    belongs_to :owner, class_name: Pipeline::User, foreign_key: :owner_id
    belongs_to :company, class_name: Pipeline::Company
  end
end
