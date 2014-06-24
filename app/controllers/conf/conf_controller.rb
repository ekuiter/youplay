class Conf::ConfController < ApplicationController
  def settings
    @max_recently_watched = current_user.max_recently_watched
    @player_skins = current_user.player_skins
    @player_skin = current_user.player_skin
  end

  def update_settings
    begin
      if current_user.max_recently_watched = params[:max_recently_watched] and
         current_user.player_skin = params[:player_skin]
         redirect_to conf_edit_settings_path, notice: t('conf.success')
       else
         redirect_to conf_edit_settings_path, alert: t('conf.failure')
       end
    rescue
      redirect_to conf_edit_settings_path, alert: $!.message
    end
  end
end
