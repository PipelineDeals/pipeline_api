# frozen_string_literal: true

module Pipeline
  class Note < Pipeline::Resource
    belongs_to :note_category, class_name: "Pipeline::NoteCategory"
    belongs_to :company, class_name: "Pipeline::Company"
    belongs_to :deal, class_name: "Pipeline::Deal"
    belongs_to :person, class_name: "Pipeline::Person"
    belongs_to :created_by_user, class_name: "Pipeline::User"
  end
end
