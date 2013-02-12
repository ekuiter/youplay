module Conf::UsersHelper

  def humanize_role(is_admin)
    is_admin ? t('conf.admin') : ''
  end

end
