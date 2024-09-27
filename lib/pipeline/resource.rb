# frozen_string_literal: true

class Pipeline::Resource < Pipeline::Base
  # add an inheritable class attribute (that works prior to Ruby 3)...
  class << self
    attr_accessor :writable_attributes
  end

  attr_reader :attributes_before, :changes

  def initialize(pipeline:, id: nil, attributes: nil)
    super(pipeline: pipeline)
    @attributes = {}
    @attributes_before = {}
    @changes = {}

    @attributes = attributes.clone || {}
    if id
      @attributes = load(id)
      @attributes_before = @attributes.clone
    else
      @attributes.each { |k, v| @changes[k] = [nil, v] }
    end
  end

  def save
    @attributes_before = if id
                           _put("#{collection_name}/#{id}.json", body: { collection_name.singularize => @attributes.slice(*@changes.keys) })
                         else
                           _post("#{collection_name}.json", body: { collection_name.singularize => @attributes.slice(*@changes.keys) })
                         end
    @attributes = @attributes_before.clone
    @changes = {}
    true
  end

  def destroy
    _delete("#{collection_name}/#{id}.json") if id
  end

  def attributes
    @attributes.clone
  end

  def attributes=(attrs)
    attrs.each { |k, v| send("#{k}=", v) }
  end

  def respond_to_missing?(_method_name, _include_private = false)
    true
  end

  def method_missing(name, *args)
    name = name.to_s
    if name.sub!(/\?$/, "")
      @attributes[name].present?
    elsif name.sub!(/=$/, "")
      check_writable_attribute_key(name)
      @attributes[name] = args[0]
      if @attributes_before[name] == @attributes[name]
        @changes.delete(name)
      else
        @changes[name] = [@attributes_before[name], @attributes[name]]
      end
    else
      @attributes[name]
    end
  end

  def reload(id = send("id"))
    @attributes_before = load(id)
    @attributes = @attributes_before.clone
    @changes = {}
    self
  end

  private

  # Explicitlyl for loading an entity from a non-standard endpoint...
  def get(endpoint)
    @attributes_before = _get(endpoint)
    @attributes = @attributes_before.clone
    @changes = {}
    self
  end

  def check_writable_attribute_key(key)
    return if self.class.writable_attributes.nil? || self.class.writable_attributes.include?(key.to_sym)

    raise "`#{key}` is not a writable attribute for an instance of #{self.class}"
  end

  def load(id)
    id ? _get("#{collection_name}/#{id}.json") : {}
  end
end

Pipeline::Account = Class.new(Pipeline::Resource)
Pipeline::Deal = Class.new(Pipeline::Resource)
Pipeline::Person = Class.new(Pipeline::Resource)
Pipeline::Company = Class.new(Pipeline::Resource)
Pipeline::Customer = Class.new(Pipeline::Resource)
Pipeline::AccountNotification = Class.new(Pipeline::Resource)
Pipeline::Document = Class.new(Pipeline::Resource)
Pipeline::Note = Class.new(Pipeline::Resource)
Pipeline::CalendarEntry = Class.new(Pipeline::Resource)
Pipeline::CalendarEvent = Class.new(Pipeline::Resource)
Pipeline::CalendarTask = Class.new(Pipeline::Resource)
Pipeline::Search = Class.new(Pipeline::Resource)
Pipeline::Comment = Class.new(Pipeline::Resource)
Pipeline::Import = Class.new(Pipeline::Resource)
module Pipeline::Admin
  Webhook = Class.new(Pipeline::Resource)
  PredefinedContactsTag = Class.new(Pipeline::Resource)
  DealCustomFieldLabel = Class.new(Pipeline::Resource)
  PersonCustomFieldLabel = Class.new(Pipeline::Resource)
  CompanyCustomFieldLabel = Class.new(Pipeline::Resource)
  CalendarEntryPriority = Class.new(Pipeline::Resource)
  CompanyCustomFieldGroup = Class.new(Pipeline::Resource)
  CompanyTag = Class.new(Pipeline::Resource)
  CustomFieldLabelDropdownEntry = Class.new(Pipeline::Resource)
  DealCustomFieldGroup = Class.new(Pipeline::Resource)
  DealLossReason = Class.new(Pipeline::Resource)
  DealWonReason = Class.new(Pipeline::Resource)
  DealStage = Class.new(Pipeline::Resource)
  DealStatus = Class.new(Pipeline::Resource)
  DealTag = Class.new(Pipeline::Resource)
  DocumentTag = Class.new(Pipeline::Resource)
  EventCategory = Class.new(Pipeline::Resource)
  LeadSource = Class.new(Pipeline::Resource)
  LeadStatus = Class.new(Pipeline::Resource)
  NoteCategory = Class.new(Pipeline::Resource)
  PersonCustomFieldGroup = Class.new(Pipeline::Resource)
  ProductLine = Class.new(Pipeline::Resource)
  RevenueType = Class.new(Pipeline::Resource)
  Team = Class.new(Pipeline::Resource)
  TodoTemplate = Class.new(Pipeline::Resource)
  TodoTemplateItem = Class.new(Pipeline::Resource)
end

require "pipeline/user"
require "pipeline/admin/feature"
