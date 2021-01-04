# name: enable-noms
# about: Allows users in Anonymous Mode to change their usernames
# version: 0.1
# url: https://github.com/paviliondev/discourse-topic-previews

require_dependency 'guardian'
require_dependency 'guardian/user_guardian'

class ::Guardian
end

module ::UserGuardian
  def can_edit_username?(user)
    return false if SiteSetting.sso_overrides_username?
    return true if is_staff?
    return false if SiteSetting.username_change_period <= 0
    return true if is_anonymous?
    is_me?(user) && ((user.post_count + user.topic_count) == 0 || user.created_at > SiteSetting.username_change_period.days.ago)
  end


  def can_edit_name?(user)
    return false unless SiteSetting.enable_names?
    return false if SiteSetting.sso_overrides_name?
    return true if is_staff?
    return true if is_anonymous?
    can_edit?(user)
  end
end