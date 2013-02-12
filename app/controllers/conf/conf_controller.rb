class Conf::ConfController < ApplicationController

  def settings
    @max_recently_watched = current_user.max_recently_watched
    @max_title_length = current_user.max_title_length
    @player_skins = current_user.player_skins
    @player_skin = current_user.player_skin
  end

  def update_settings
    alert = nil
    begin
      success_max_recently_watched = current_user.max_recently_watched = params[:max_recently_watched]
    rescue
      alert = alert.nil? ? $!.message : "#{alert} / #{$!.message}"
    end
    begin
      success_max_title_length = current_user.max_title_length = params[:max_title_length]
    rescue
      alert = alert.nil? ? $!.message : "#{alert} / #{$!.message}"
    end
    begin
      success_player_skin = current_user.player_skin = params[:player_skin]
    rescue
      alert = alert.nil? ? $!.message : "#{alert} / #{$!.message}"
    end
    if alert.nil?
      if success_max_recently_watched && success_max_title_length && success_player_skin
        redirect_to conf_edit_settings_path, notice: t('conf.success')
      else
        redirect_to conf_edit_settings_path, alert: t('conf.failure')
      end
    else
      redirect_to conf_edit_settings_path, alert: alert
    end
  end

end
