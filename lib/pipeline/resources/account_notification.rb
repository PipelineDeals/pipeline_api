module Pipeline
  class AccountNotifications < Pipeline::Resource
    belongs_to :account, class_name: Pipeline::Account
  end
end

