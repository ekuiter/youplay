class AdminController < ApplicationController
  before_filter :admin_required

  def admin_required
    unless current_user.admin
      flash[:alert] = t("bad_request")
      redirect_to player_path
    end
  end
end
