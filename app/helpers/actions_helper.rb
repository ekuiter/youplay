module ActionsHelper
  def modules
    {
        t('modules.player') => player_path,
        t('modules.log') => log_path,
        t('modules.stats') => stats_path,
        t('modules.conf') => conf_path,
        t('modules.reader') => reader_path
    }
  end
  
  def conf_actions
    actions = [
      { name: t('conf.edit_settings'), path: conf_edit_settings_path },
      { name: t('devise.edit_account'), path: edit_user_registration_path },
      { name: t('conf.manage_people'), path: conf_people_path },
      { name: t('conf.manage_categories'), path: conf_categories_path }
    ]
    actions.push({ name: t('conf.manage_users'), path: conf_users_path }) if current_user.admin
    actions
  end
  
  def log_actions
    [
      { name: t('video_list.all_videos'), path: log_path },
      { name: t('video_list.only_favorites'), path: log_path(search: "favorites") },
      { name: t('video_list.stats'), path: search_path(@search, nil, stats_path) }      
    ]
  end
  
  def reader_actions
    [
      { name: t('reader.read'), path: reader_path },
      { name: t('reader.subscribe.button'), path: reader_subscribe_path },
      { name: t('reader.manage_hiding_rules'), path: reader_hiding_rules_path },
      { name: t('reader.manage_hidden'), path: reader_hidden_path }
    ]
  end

  def stats_actions
    [
      { name: t("video_list.all_videos"), path: stats_path },
      { name: t('video_list.only_favorites'), path: search_path("favorites", nil, stats_path) },
      { name: t('stats.search'), path: search_path(@search, nil, log_path) }      
    ]
  end
end
