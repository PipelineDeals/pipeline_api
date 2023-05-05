module Pipeline
  class Document < Pipeline::Resource
    belongs_to :user, class_name: Pipeline::User
    belongs_to :deal, class_name: Pipeline::Deal
    belongs_to :person, class_name: Pipeline::Person
    belongs_to :company, class_name: Pipeline::Company
  end
end

