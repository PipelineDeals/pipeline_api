class Pipeline::Resource < Pipeline::Base
  def self.extended(base)
    puts "extended #{base}"
  end

  attr_reader :hash

  def initialize(pipeline:, hash:)
    @hash = hash
    super(pipeline: pipeline)
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
