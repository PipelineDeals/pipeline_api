# frozen_string_literal: true

class Pipeline::Resource < Pipeline::Base
  def initialize(pipeline:, id: nil, attributes: nil)
    super(pipeline: pipeline)
    @attributes = {}
    @attributes_before = {}
    @changes = {}
    @attributes = if id
              load(id)
            else
              attributes.clone || {}
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

  def method_missing(name, *args)
    name = name.to_s
    if name.sub!(/\?$/, "")
      @attributes[name].present?
    elsif name.sub!(/=$/, "")
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

  def reload
    @attributes_before = load
    @attributes = @attributes_before.clone
    @changes = {}
    self
  end

  private

  def load(id = send("id"))
    id ? _get("#{collection_name}/#{id}.json") : {}
  end
end

Pipeline::Deal = Class.new(Pipeline::Resource)
Pipeline::Person = Class.new(Pipeline::Resource)
Pipeline::Company = Class.new(Pipeline::Resource)
Pipeline::User = Class.new(Pipeline::Resource)
Pipeline::AccountNotification = Class.new(Pipeline::Resource)
Pipeline::Document = Class.new(Pipeline::Resource)
Pipeline::Note = Class.new(Pipeline::Resource)
Pipeline::CalendarEntry = Class.new(Pipeline::Resource)
Pipeline::CalendarEvent = Class.new(Pipeline::Resource)
Pipeline::CalendarTask = Class.new(Pipeline::Resource)
module Pipeline::Admin
  Webhook = Class.new(Pipeline::Resource)
end

require "pipeline/auth"
