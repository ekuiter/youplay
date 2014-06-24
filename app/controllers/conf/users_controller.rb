class Conf::UsersController < AdminController
  before_filter :set_user, only: [:edit, :update, :destroy]
  before_filter :user_params, only: [:create, :update]
  
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new @user_params
    @user.admin = @admin
    if @user.save
      redirect_to conf_users_path, notice: t('conf.users.create.success', user: @user.username)
    else
      render 'new'
    end
  end

  def update
    @user.full_name = @user_params[:full_name]
    @user.email = @user_params[:email]
    @user.admin = @admin unless @user == current_user
    unless @user_params[:password].empty?
      @user.password = @user_params[:password]
      @user.password_confirmation = @user_params[:password_confirmation]
    end
    if @user.save
      redirect_to conf_users_path, notice: t('conf.users.update.success', user: @user.username)
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to conf_users_path, notice: t('conf.users.destroy', user: @user.username)
  end
  
  private
  
  def set_user
    @user = User.find params[:id]
  end
  
  def user_params
    @user_params = params[:user]
    @admin = @user_params.delete(:admin).to_i == 1
  end
end