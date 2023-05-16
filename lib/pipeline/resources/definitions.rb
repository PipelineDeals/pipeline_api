module Pipeline
  class Account < Pipeline::Resource; end
  class Auth < Pipeline::Resource; end
  class DealStage < Pipeline::AdminResource; end
  class NoteCategory < Pipeline::AdminResource; end
  class DealCustomFieldLabel < Pipeline::AdminResource; end
  class PersonCustomFieldLabel < Pipeline::AdminResource; end
  class CompanyCustomFieldLabel < Pipeline::AdminResource; end
  class CustomFieldLabelDropdownEntry < Pipeline::AdminResource; end
  class LeadStatus < Pipeline::AdminResource; end
  class LeadSource < Pipeline::AdminResource; end
  class PredefinedContactsTag < Pipeline::AdminResource; end
  class EventCategory < Pipeline::AdminResource; end
  class Webhook < Pipeline::AdminResource; end

  class Deal < Pipeline::Resource; end
  class Person < Pipeline::Resource; end
  class Company < Pipeline::Resource; end
  class Customer < Pipeline::Resource; end
  class Activity < Pipeline::Resource; end
  class CalendarEntry < Pipeline::Resource; end
  class CalendarTask < Pipeline::Resource; end
  class CalendarEvent < Pipeline::Resource; end
  class Document < Pipeline::Resource; end
  class User < Pipeline::Resource; end
  class Note < Pipeline::Resource; end
  class AccountNotification < Pipeline::Resource; end
end
