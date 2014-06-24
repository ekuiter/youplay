class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :tasks

  def tasks
    params[:user].delete :role if params[user:[:role]].present?
    @current_path = request.fullpath
  end

  def signed_in_root_path(resource_or_scope)
    resource_or_scope
    player_path
  end
  
  def nothing
    render nothing: true
  end
end
