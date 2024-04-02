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
Pipeline::AccountNotification = Class.new(Pipeline::Resource)
Pipeline::Document = Class.new(Pipeline::Resource)
Pipeline::Note = Class.new(Pipeline::Resource)
Pipeline::CalendarEntry = Class.new(Pipeline::Resource)
Pipeline::CalendarEvent = Class.new(Pipeline::Resource)
Pipeline::CalendarTask = Class.new(Pipeline::Resource)
module Pipeline::Admin
  Webhook = Class.new(Pipeline::Resource)
end

require "pipeline/user"
require "pipeline/admin/feature"
