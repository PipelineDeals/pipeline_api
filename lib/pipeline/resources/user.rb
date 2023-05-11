module Pipeline
  class User < Pipeline::Resource
    has_many :companies, class_name: "Pipeline::Company"
    has_many :deals, class_name: "Pipeline::Deal"
    has_many :people, class_name: "Pipeline::Person"
    has_many :documents, class_name: "Pipeline::Document"
    has_many :notes, class_name: "Pipeline::Note"
    has_many :calendar_entries, class_name: "Pipeline::CalendarEntry"
    has_many :calendar_tasks, class_name: "Pipeline::CalendarTask"
    has_many :calendar_event, class_name: "Pipeline::CalendarEvent"
    belongs_to :account, class_name: "Pipeline::Account"
  end
end

