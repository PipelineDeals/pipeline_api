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
    each(per_page: 1)&.first
  end

  def each(per_page: nil)
    page = 1
    pages = nil
    while pages.nil? || page < pages
      response = read_page(page: page, per_page: per_page)
      pages ||= response.is_a?(Array) || response[collection_name] ? 1 : response["pagination"]["pages"]
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
Pipeline::People = Class.new(Pipeline::Collection)
Pipeline::Deals = Class.new(Pipeline::Collection)
Pipeline::Users = Class.new(Pipeline::Collection)
Pipeline::AccountNotifications = Class.new(Pipeline::Collection)
Pipeline::Documents = Class.new(Pipeline::Collection)
Pipeline::Notes = Class.new(Pipeline::Collection)
Pipeline::CalendarEntries = Class.new(Pipeline::Collection)
Pipeline::CalendarEvents = Class.new(Pipeline::Collection)
Pipeline::CalendarTasks = Class.new(Pipeline::Collection)
module Pipeline::Admin
  Webhooks = Class.new(Pipeline::Collection)
end
