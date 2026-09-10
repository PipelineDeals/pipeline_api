# frozen_string_literal: true

# The current user's own record, via the singular self-service `profile.json`
# endpoint (p.core Api::V3::ProfilesController). A user may read and update
# their own record here without account-admin rights — unlike Pipeline::User,
# whose save targets the admin-gated `users/:id` endpoint.
class Pipeline::Profile < Pipeline::Resource
  # ProfilesController#update always acts on the authenticated user and reads
  # params[:user], so this saves to the singular endpoint under the :user key
  # rather than Resource#save's `collection/id` path + class-derived key.
  def save
    @attributes_before = _put("profile.json", body: { user: @attributes.slice(*@changes.keys) })
    @attributes = @attributes_before.clone
    @changes = {}
    true
  end
end
