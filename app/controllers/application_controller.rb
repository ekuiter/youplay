class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :tasks
  include YoutubeConnector
  include HttpRequest
  include Player::VideoPlayer
  
  def nothing
    render nothing: true
  end

  def tasks
    params[:user].delete :role if params[user:[:role]].present?
    @current_path = request.fullpath
    $current_user = current_user
  end

  def bad_request
    flash[:alert] = t("bad_request")
    redirect_to player_path
  end

  helper_method :bad_request

  def signed_in_root_path(resource_or_scope)
    resource_or_scope
    conf_path
  end

  def user_browser
    user_agent = request.env['HTTP_USER_AGENT'].downcase
    begin
      if user_agent.index('msie') && !user_agent.index('opera') && !user_agent.index('webtv')
        return 'Internet Explorer'
      elsif user_agent.index('gecko/')
        return 'Gecko'
      elsif user_agent.index('opera')
        return 'Opera'
      elsif user_agent.index('konqueror')
        return 'Konqueror'
      elsif user_agent.index('ipod')
        return 'iPod'
      elsif user_agent.index('ipad')
        return 'iPad'
      elsif user_agent.index('iphone')
        return 'iPhone'
      elsif user_agent.index('chrome/')
        return 'Chrome'
      elsif user_agent.index('applewebkit/')
        return 'Safari'
      elsif user_agent.index('googlebot/')
        return 'Google Bot'
      elsif user_agent.index('msnbot')
        return 'MSN Bot'
      elsif user_agent.index('yahoo! slurp')
        return 'Yahoo Bot'
      #Everything thinks it's mozilla, so this goes last
      elsif user_agent.index('mozilla/')
        return 'Gecko'
      else
        return 'Unknown'
      end
    end
  end
  
  def user_from_params
    if !params[:username].nil? && !params[:password].nil?
      user = User.where(username: params[:username]).first
      return nil unless user
      @client = youtube_connect current_user: user, access_token: user.access_token,
                                refresh_token: user.refresh_token, expires_in: user.expires_in
      user
    end
  end

end
