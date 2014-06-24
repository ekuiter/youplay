class Api::AuthenticatedController < Api::ApiController
  before_filter :authenticate_by_token!
  
  private
  
  def authenticate_by_token!
    begin
      raise "no token given" unless params[:token].presence
      id, token = params[:token].split(':')
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