module Pipeline
  class Account < Pipeline::Resource
    include ActiveResource::Singleton
    def self.account(options = {})
      add_keys(options[:params] ||= {})
      find(options)
    end

    has_many :companies, class_name: "Pipeline::Company"
    has_many :customers, class_name: "Pipeline::Customer"
    has_many :deals, class_name: "Pipeline::Deal"
    has_many :people, class_name: "Pipeline::Person"
    has_many :documents, class_name: "Pipeline::Document"
    has_many :notes, class_name: "Pipeline::Note"
    has_many :calendar_entries, class_name: "Pipeline::CalendarEntry"
    has_many :calendar_tasks, class_name: "Pipeline::CalendarTask"
    has_many :calendar_events, class_name: "Pipeline::CalendarEvent"
    has_many :users, class_name: "Pipeline::User"
    has_many :notifications, class_name: "Pipeline::AccountNotification"

    has_many :deal_stages, class_name: "Pipeline::DealStage"
    has_many :note_categories, class_name: "Pipeline::AdminResource"
    has_many :deal_custom_field_labels, class_name: "Pipeline::AdminResource"
    has_many :person_custom_field_labels, class_name: "Pipeline::AdminResource"
    has_many :company_custom_field_labels, class_name: "Pipeline::AdminResource"
    has_many :custom_field_label_dropdown_entries, class_name: "Pipeline::AdminResource"
    has_many :lead_statuses, class_name: "Pipeline::AdminResource"
    has_many :lead_sources, class_name: "Pipeline::AdminResource"
    has_many :predefined_contacts_tags, class_name: "Pipeline::AdminResource"
    has_many :event_categories, class_name: "Pipeline::AdminResource"
  end
end
