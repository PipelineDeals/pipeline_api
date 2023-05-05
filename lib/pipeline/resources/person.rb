module Pipeline
  class Person < Pipeline::Resource
    has_many :deals, class_name: "Pipeline::Deal"
    has_many :documents, class_name: "Pipeline::Document"
    has_many :notes, class_name: "Pipeline::Note"
    has_many :calendar_entries, class_name: "Pipeline::CalendarEntry"
    belongs_to :company, class_name: "Pipeline::Company"
    belongs_to :user, class_name: "Pipeline::User"
    belongs_to :lead_source, class_name: "Pipeline::LeadSource"
    belongs_to :lead_status, class_name: "Pipeline::LeadStatus"
    has_many :predfined_contacts_tags, class_name: "Pipeline::PredefinedContactsTag"
  end
end
