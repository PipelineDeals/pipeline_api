# frozen_string_literal: true

require "rubygems"

class Pipeline
  VERSION = "1.0.0"

  attr_reader :url, :prefix
  attr_accessor :api_key, :app_key, :jwt

  def initialize(url: "https://api.pipelinecrm.com", prefix: "/api/v3", api_key: nil, app_key: nil, jwt: nil)
    @url = url
    @prefix = prefix
    @api_key = api_key
    @app_key = app_key
    @jwt = jwt
  end

  def authenticate(app_key, email, password, _mfa_code = nil)
    Pipeline::Auth.new(pipeline: self).authenticate(app_key, email, password, mfa_code)
  end

  def authenticated?
    jwt.present? || (api_key.present? && app_key.present?)
  end

  def revoke_jwt
    #  Pipeline::Auth.delete(:revoke)
  end

  def refresh_jwt; end

  def people
    Pipeline::People.new(pipeline: self)
  end

  def deals
    Pipeline::Deals.new(pipeline: self)
  end

  def companies
    Pipeline::Companies.new(pipeline: self)
  end

  def users
    Pipeline::Users.new(pipeline: self)
  end

  def account_notifications
    Pipeline::AccountNotifications.new(pipeline: self)
  end

  def documents
    Pipeline::Documents.new(pipeline: self)
  end

  def notes
    Pipeline::Notes.new(pipeline: self)
  end

  def calendar_entries
    Pipeline::CalendarEntries.new(pipeline: self)
  end

  def calendar_events
    Pipeline::CalendarEvents.new(pipeline: self)
  end

  def calendar_tasks
    Pipeline::CalendarTasks.new(pipeline: self)
  end

  def webhooks
    Pipeline::Admin::Webhooks.new(pipeline: self)
  end

  # account
  # user
  # users
  # people
  # deals
  # companies
  # notes
  # documents
  # calendar_entires
  # calendar_events
  # calendar_tasks
  # account_notifications
  #
  # deal_stages
  # note_categories
  # deal_custom_field_labels
  # person_custom_field_labels
  # company_custom_field_labels
  # custom_field_label_dropdown_entries
  # lead_statuses
  # lead_sources
  # predefined_contacts_tags
  # event_categories
end

require "pipeline/base"
