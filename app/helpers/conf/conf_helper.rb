module Conf::ConfHelper

  def conf_actions
    actions = {
        t("conf.edit_settings") => conf_edit_settings_path,
        t("devise.edit_account") => edit_user_registration_path,
        t("conf.manage_people") => conf_people_path
    }
    actions[t("conf.manage_users")] = conf_users_path if current_user.admin
    return actions
  end

end
