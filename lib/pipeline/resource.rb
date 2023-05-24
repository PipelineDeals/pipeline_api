class Pipeline::Resource < Pipeline::Base
  def self.extended(base)
    puts "extended #{base}"
  end

  attr_reader :hash
  attr_reader :before
  attr_reader :changes
  attr_reader :_id

  def initialize(pipeline:, id: nil)
    super(pipeline: pipeline)
    @hash = {}
    @before = {}
    @changes = {}
    @_id = id
    reload
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

  def attributes= new_hash
    new_hash.each { |k, v| send("#{k}=", v) }
  end

  def method_missing(name, *args, &block)
    name = name.to_s
    if (name.sub!(/\?$/, ""))
      hash[name].present?
    elsif (name.sub!(/\=$/, ""))
      hash[name] = args[0]
      if before[name] != hash[name]
        changes[name] = [before[name], hash[name]]
      else
        changes.delete(name)
      end
    else
      hash[name]
    end
  end

  def reload
    @before = @_id ? _get("#{collection_name}/#{@_id}.json") : {}
    @hash = @before.clone
    @changes = {}
    self
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
