class YoutubeController < ApplicationController

  def connect
    if !current_user.access_token.blank? && !current_user.refresh_token.blank?
      redirect_to player_path, notice: t('youtube.failure', application_name: t('application.name'))
    else
      @grant_access_url = params[:state] ? grant_access_url(params[:state]) : grant_access_url
      render 'access_denied' if params[:error] == 'access_denied'
      if params[:code]
        tokens = receive_tokens params[:code]
        current_user.tokens = tokens
        current_user.save
        success = t 'youtube.success', application_name: t('application.name')
        if params[:state]
          if params[:state].include? 'player_video_'
            redirect_to "#{play_path}?#{params[:state].gsub('player_video_', '')}", notice: success
          elsif params[:state].include? 'conf'
            redirect_to conf_edit_settings_path, notice: success
          else
            redirect_to player_path, notice: success
          end
        else
          redirect_to player_path, notice: success
        end
      end
    end
  end

  def reset
    current_user.tokens = {access_token: '', refresh_token: '', expires_in: ''}
    current_user.save
    redirect_to conf_edit_settings_path, notice: t('youtube.reset_success', application_name: t('application.name'))
  end
  
  def channel_info
    if params[:channels].is_a? Array
      channels = [params[:i]]
      params[:channels].each do |data|
        split = data.split(':')
        channel = YouplayChannel.new(id: split[1], provider: split[0].to_sym).fetch
        channels.push username: (channel.name.length > 25 ? channel.name[0..25] + "&hellip;" : channel.name), url: channel.url
      end
      render json: channels
    else
      render nothing: true
    end
  end

end
