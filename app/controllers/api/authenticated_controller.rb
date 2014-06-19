class Api::AuthenticatedController < Api::ApiController
  before_filter :authenticate_user_from_token!
  
  private
  
  def authenticate_user_from_token!
    begin
      raise "no token given" unless params[:token].presence
      parts = params[:token].split(':')
      id = parts[0]
      token = parts[1]
      user = User.find(id) rescue raise("user not found")

      if user && Devise.secure_compare(user.authentication_token, token)
        sign_in user, store: false
      else
        raise "token invalid"
      end
    rescue Exception => e
      render json: { error: e.message }
    end
  end
end