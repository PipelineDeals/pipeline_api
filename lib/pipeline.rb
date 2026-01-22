# frozen_string_literal: true

require "rubygems"
require "active_support/all"

class Pipeline
  attr_reader :url, :prefix
  attr_accessor :api_key, :app_key, :jwt, :account_key

  def initialize(url: "https://api.pipelinecrm.com", prefix: "/api/v3", api_key: nil, app_key: nil, account_key: nil, jwt: nil)
    @url = url
    @prefix = prefix
    @api_key = api_key
    @app_key = app_key
    @account_key = account_key
    @jwt = jwt && ActiveSupport::HashWithIndifferentAccess.new(jwt)
  end

  def authenticate(app_key:, email:, password:, mfa_code: nil)
    @user = Pipeline::User.new(pipeline: self).authenticate(app_key: app_key, email: email, password: password, mfa_code: mfa_code)
  end

  def authenticated?
    jwt.present? || (api_key.present? && app_key.present?)
  end

  def revoke_jwt
    return unless jwt.present?

    user.revoke_jwt
    @user = @account = nil
  end

  def renew_jwt
    user.renew_jwt if jwt.present?
  end

  def user
    @user ||= Pipeline::User.new(pipeline: self).send(:get, "profile.json")
  end

  def account
    @account ||= Pipeline::Account.new(pipeline: self).send(:get, "account.json")
  end

  def people
    Pipeline::People.new(pipeline: self)
  end

  def deals
    Pipeline::Deals.new(pipeline: self)
  end

  def companies
    Pipeline::Companies.new(pipeline: self)
  end

  def customers
    Pipeline::Customers.new(pipeline: self)
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

  def searches
    Pipeline::Searches.new(pipeline: self)
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

  def comments
    Pipeline::Comments.new(pipeline: self)
  end

  def predefined_contacts_tags
    Pipeline::Admin::PredefinedContactsTags.new(pipeline: self)
  end

  def deal_custom_field_labels
    Pipeline::Admin::DealCustomFieldLabels.new(pipeline: self)
  end

  def person_custom_field_labels
    Pipeline::Admin::PersonCustomFieldLabels.new(pipeline: self)
  end

  def company_custom_field_labels
    Pipeline::Admin::CompanyCustomFieldLabels.new(pipeline: self)
  end

  def calendar_entry_priorities
    Pipeline::Admin::CalendarEntryPriorities.new(pipeline: self)
  end

  def company_custom_field_groups
    Pipeline::Admin::CompanyCustomFieldGroups.new(pipeline: self)
  end

  def company_tags
    Pipeline::Admin::CompanyTags.new(pipeline: self)
  end

  def custom_field_label_dropdown_entries
    Pipeline::Admin::CustomFieldLabelDropdownEntries.new(pipeline: self)
  end

  def deal_custom_field_groups
    Pipeline::Admin::DealCustomFieldGroups.new(pipeline: self)
  end

  def deal_loss_reasons
    Pipeline::Admin::DealLossReasons.new(pipeline: self)
  end

  def deal_won_reasons
    Pipeline::Admin::DealWonReasons.new(pipeline: self)
  end

  def deal_stages
    Pipeline::Admin::DealStages.new(pipeline: self)
  end

  def deal_statuses
    Pipeline::Admin::DealStatuses.new(pipeline: self)
  end

  def deal_tags
    Pipeline::Admin::DealTags.new(pipeline: self)
  end

  def document_tags
    Pipeline::Admin::DocumentTags.new(pipeline: self)
  end

  def event_categories
    Pipeline::Admin::EventCategories.new(pipeline: self)
  end

  def lead_sources
    Pipeline::Admin::LeadSources.new(pipeline: self)
  end

  def lead_statuses
    Pipeline::Admin::LeadStatuses.new(pipeline: self)
  end

  def note_categories
    Pipeline::Admin::NoteCategories.new(pipeline: self)
  end

  def person_custom_field_groups
    Pipeline::Admin::PersonCustomFieldGroups.new(pipeline: self)
  end

  def product_lines
    Pipeline::Admin::ProductLines.new(pipeline: self)
  end

  def revenue_types
    Pipeline::Admin::RevenueTypes.new(pipeline: self)
  end

  def teams
    Pipeline::Admin::Teams.new(pipeline: self)
  end

  def todo_templates
    Pipeline::Admin::TodoTemplates.new(pipeline: self)
  end

  def todo_template_items
    Pipeline::Admin::TodoTemplateItems.new(pipeline: self)
  end

  def webhooks
    Pipeline::Admin::Webhooks.new(pipeline: self)
  end

  def features
    Pipeline::Admin::Features.new(pipeline: self)
  end

  def imports
    Pipeline::Imports.new(pipeline: self)
  end

  def call_logs
    Pipeline::CallLogs.new(pipeline: self)
  end
end

require "pipeline/base"
