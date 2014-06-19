class Api::ApiController < ActionController::Base
  include HttpRequest
  include Providers
  
  respond_to :json
  around_filter :error_handler
  
  private
  
  def error_handler
    begin
      yield
    rescue Exception => e
      render json: { error: e.message }
    end
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
end