class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :remove_role
  include YoutubeConnector
  include HttpRequest

  def remove_role
    params[:user].delete :role if params[user:[:role]].present?
  end

  def bad_request
    flash[:alert] = "Bad request."
    redirect_to player_path
  end

  helper_method :bad_request

  def signed_in_root_path resource_or_scope
    conf_path
  end

  def user_browser
    user_agent = request.env["HTTP_USER_AGENT"].downcase
    user_browser ||= begin
      if user_agent.index("msie") && !user_agent.index("opera") && !user_agent.index("webtv")
        "Internet Explorer"
      elsif user_agent.index("gecko/")
        "Gecko"
      elsif user_agent.index("opera")
        "Opera"
      elsif user_agent.index("konqueror")
        "Konqueror"
      elsif user_agent.index("ipod")
        "iPod"
      elsif user_agent.index("ipad")
        "iPad"
      elsif user_agent.index("iphone")
        "iPhone"
      elsif user_agent.index("chrome/")
        "Chrome"
      elsif user_agent.index("applewebkit/")
        "Safari"
      elsif user_agent.index("googlebot/")
        "Google Bot"
      elsif user_agent.index("msnbot")
        "MSN Bot"
      elsif user_agent.index("yahoo! slurp")
        "Yahoo Bot"
        #Everything thinks it's mozilla, so this goes last
      elsif user_agent.index("mozilla/")
        "Gecko"
      else
        "Unknown"
      end
    end
    return user_browser
  end

end
