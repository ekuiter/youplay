module Conf::ConfHelper

  def conf_actions
    actions = [
      { name: t('conf.edit_settings'), path: conf_edit_settings_path },
      { name: t('devise.edit_account'), path: edit_user_registration_path },
      { name: t('conf.manage_people'), path: conf_people_path }
    ]
    actions.push({ name: t('conf.manage_users'), path: conf_users_path }) if current_user.admin
    actions
  end

end
