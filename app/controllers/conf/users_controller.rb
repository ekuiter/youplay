class Conf::UsersController < AdminController

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find params[:id]
  end

  def create
    user_params = params[:user]
    admin = params[:user][:admin].to_i == 1 ? true : false
    logger.debug "Admin: #{params[:user][:admin]}"
    logger.debug "Admin: #{admin}"
    user_params.delete :admin
    @user = User.new user_params
    @user.admin = admin
    if @user.save
      redirect_to conf_users_path, notice: t('conf.users.create.success', user: @user.username)
    else
      render 'new'
    end
  end


  def update
    begin
      notice = nil
      user_params = params[:user]
      admin = user_params[:admin].to_i == 1 ? true : false
      @user = User.find params[:id]
      if @user.update_attributes full_name: user_params[:full_name],
                                 email: user_params[:email]
        @user.admin = admin unless @user == current_user
        if @user.save
          if user_params[:password].empty?
            notice = t 'conf.users.update.success', user: @user.username
          else
            if @user.update_attributes password: user_params[:password],
                                       password_confirmation: user_params[:password_confirmation]
              notice = t 'conf.users.update.success', user: @user.username
            end
          end
        end
      end
      if notice
        flash.now.notice = t 'conf.users.update.success', user: @user.username
      end
      render 'edit'
    rescue RuntimeError
      redirect_to conf_users_path, alert: $!.message
    end
  end

  def destroy
    begin
      @user = User.find(params[:id])
      @user.destroy
      redirect_to conf_users_path, notice: t('conf.users.destroy', user: @user.username)
    rescue RuntimeError
      redirect_to conf_users_path, alert: $!.message
    end
  end

end
