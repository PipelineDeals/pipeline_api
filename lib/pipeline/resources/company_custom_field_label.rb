module Pipeline
  class CompanyCustomFieldLabel < Pipeline::AdminResource
    has_many :custom_field_label_dropdown_entries, class_name: Pipeline::CustomFieldLabelDropdownEntry
  end
end
