# frozen_string_literal: true

class Pipeline::Collection < Pipeline::Base
  attr_reader :conditions, :sort_by

  def find(id)
    raise "find doesn't honor where or order." if conditions.present? || sort_by.present?

    [module_name, collection_name.singularize.camelize].join("::").constantize.new(pipeline: pipeline, id: id)
  end

  def new(attrs = nil)
    entry = [module_name, collection_name.singularize.camelize].join("::").constantize.new(pipeline: pipeline)
    entry.attributes = attrs if attrs
    entry
  end

  def create(attrs)
    entry = new(attrs)
    entry.save
    entry
  end

  def where(conditions)
    @conditions ||= {}
    @conditions.merge!(conditions)
    self
  end

  def order(sort_by)
    @sort_by = sort_by
    self
  end

  def first
    entries = []
    each(per_page: 1) { |entry| entries << entry }
    entries.first
  end

  def each(per_page: nil)
    page = 1
    pages = nil
    while pages.nil? || page <= pages
      response = read_page(page: page, per_page: per_page)
      pages = (response.is_a?(Hash) && response.dig("pagination", "pages")) || 1
      list = response.is_a?(Array) ? response : (response[collection_name] || response["entries"])
      list.each do |attrs|
        entry = [module_name, collection_name.singularize.camelize].join("::").constantize.new(pipeline: pipeline, attributes: attrs)
        yield(entry)
      end
      page += 1
    end
  end

  def map
    values = []
    each { |entry| values << yield(entry) }
    values
  end

  def all
    entries = []
    each { |entry| entries << entry }
    entries
  end

  private

  def read_page(page: 1, per_page: nil)
    query = { page: page, per_page: per_page }.select { |_k, v| v.present? }
    query.merge!(conditions: conditions) if conditions.present?
    _get("#{collection_name}.json", query: query)
  end
end

Pipeline::Companies = Class.new(Pipeline::Collection)
Pipeline::Customers = Class.new(Pipeline::Collection)
Pipeline::People = Class.new(Pipeline::Collection)
Pipeline::Deals = Class.new(Pipeline::Collection)
Pipeline::Users = Class.new(Pipeline::Collection)
Pipeline::AccountNotifications = Class.new(Pipeline::Collection)
Pipeline::Documents = Class.new(Pipeline::Collection)
Pipeline::Notes = Class.new(Pipeline::Collection)
Pipeline::CalendarEntries = Class.new(Pipeline::Collection)
Pipeline::CalendarEvents = Class.new(Pipeline::Collection)
Pipeline::CalendarTasks = Class.new(Pipeline::Collection)
Pipeline::Searches = Class.new(Pipeline::Collection)
Pipeline::Comments = Class.new(Pipeline::Collection)
Pipeline::Imports = Class.new(Pipeline::Collection)
Pipeline::CallLogs = Class.new(Pipeline::Collection)
module Pipeline::Admin
  Webhooks = Class.new(Pipeline::Collection)
  Features = Class.new(Pipeline::Collection)
  PredefinedContactsTags = Class.new(Pipeline::Collection)
  DealCustomFieldLabels = Class.new(Pipeline::Collection)
  PersonCustomFieldLabels = Class.new(Pipeline::Collection)
  CompanyCustomFieldLabels = Class.new(Pipeline::Collection)
  CalendarEntryPriorities = Class.new(Pipeline::Collection)
  CompanyCustomFieldGroups = Class.new(Pipeline::Collection)
  CompanyTags = Class.new(Pipeline::Collection)
  CustomFieldLabelDropdownEntries = Class.new(Pipeline::Collection)
  DealCustomFieldGroups = Class.new(Pipeline::Collection)
  DealLossReasons = Class.new(Pipeline::Collection)
  DealWonReasons = Class.new(Pipeline::Collection)
  DealStages = Class.new(Pipeline::Collection)
  DealStatuses = Class.new(Pipeline::Collection)
  DealTags = Class.new(Pipeline::Collection)
  DocumentTags = Class.new(Pipeline::Collection)
  EventCategories = Class.new(Pipeline::Collection)
  LeadSources = Class.new(Pipeline::Collection)
  LeadStatuses = Class.new(Pipeline::Collection)
  NoteCategories = Class.new(Pipeline::Collection)
  PersonCustomFieldGroups = Class.new(Pipeline::Collection)
  ProductLines = Class.new(Pipeline::Collection)
  RevenueTypes = Class.new(Pipeline::Collection)
  Teams = Class.new(Pipeline::Collection)
  TodoTemplates = Class.new(Pipeline::Collection)
  TodoTemplateItems = Class.new(Pipeline::Collection)
end
