# frozen_string_literal: true

class Pipeline::Resource < Pipeline::Base
  attr_reader :hash, :before, :changes, :_id

  def initialize(pipeline:, id: nil, hash: nil)
    super(pipeline: pipeline)
    if id
      @hash = load
    else
      @hash = hash || {}
    end
    @before = {}
    @changes = {}
    @_id = send("id") || id
  end

  def save
    @before = if _id
                _put("#{collection_name}/#{@_id}.json", body: { collection_name.singularize => @hash.slice(*changes.keys) })
              else
                _post("#{collection_name}.json", body: { collection_name.singularize => @hash.slice(*changes.keys) })
              end
    @hash = @before.clone
    @changes = {}
    true
  end

  def attributes
    @hash.clone
  end

  def attributes=(new_hash)
    new_hash.each { |k, v| send("#{k}=", v) }
  end

  def method_missing(name, *args)
    name = name.to_s
    if name.sub!(/\?$/, "")
      hash[name].present?
    elsif name.sub!(/=$/, "")
      hash[name] = args[0]
      if before[name] == hash[name]
        changes.delete(name)
      else
        changes[name] = [before[name], hash[name]]
      end
    else
      hash[name]
    end
  end

  def reload
    @before = load
    @hash = @before.clone
    @changes = {}
    self
  end

  private

  def load
    @_id ? _get("#{collection_name}/#{@_id}.json") : {}
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
