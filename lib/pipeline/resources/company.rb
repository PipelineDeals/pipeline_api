module Pipeline
  class Company < Pipeline::Resource
    has_many :deals, class_name: Pipeline::Deal
    has_many :people, class_name: Pipeline::Person
    has_many :documents, class_name: Pipeline::Document
    has_many :notes, class_name: Pipeline::Note
    has_many :calendar_entries, class_name: Pipeline::CalendarEntry
  end
end

