# frozen_string_literals: true

class Pipeline::Collection < Pipeline::Base
  def self.extended(base)
    puts "extended #{base}"
  end

  attr_reader :conditions
  attr_reader :sort_by

  def find(id)
    raise "find doesn't honor where or order." if conditions.present? || sort_by.present?

    "Pipeline::#{collection_name.singularize.camelize}".constantize.new(pipeline: pipeline, id: id)
  end

  def new(hash = nil)
    entry = "Pipeline::#{collection_name.singularize.camelize}".constantize.new(pipeline: pipeline)
    entry.attributes = hash if hash
    entry
  end

  def create(hash)
    entry = new(hash)
    entry.save
    entry
  end

  def where(conditions)
    @conditions ||= {}
    @conditions.merge!(conditions)
  end

  def order(sort_by)
    @sort_by = sort_by
  end

  def each
    page = 1
    pages = nil
    while (pages.nil? || page < pages)
      response = read_page(page: page)
      pages ||= response["pagination"]["pages"]
      response["entries"].each do |hash|
        entry = "Pipeline::#{collection_name.singularize.camelize}".constantize.new(pipeline: pipeline, hash: hash)
        yield(entry)
      end
    end
  end

  def all
    entries = []
    each { |entry| entries << entry }
    entries
  end

  private

  def read_page(page: 1, per_page: 200)
    _get("#{collection_name}.json", query: { conditions: conditions, page: page, per_page: per_page })
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
