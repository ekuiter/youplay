class Api::AuthController < Api::ApiController
  def login
     raise "username or password not given" unless params[:username].presence && params[:password].presence
     user = User.where(username: params[:username]).first
     raise("login data incorrect") unless user
     if user.valid_password?(params[:password])
       sign_in user, store: false
       render json: user.to_json(methods: :token)
     else
       raise "login data incorrect"
     end
  end
end