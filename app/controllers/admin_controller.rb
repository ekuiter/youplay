class AdminController < ApplicationController

  before_filter :admin_required

  def admin_required
    bad_request unless current_user.admin
  end

end
