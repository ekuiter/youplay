class Reader::WorkerController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:update, :tidy]
  
  def update
    User.first.update_videos if upload_pass_valid?
    render nothing: true
  end
  
  def tidy
    User.first.tidy_videos if upload_pass_valid?
    render nothing: true
  end

  private
  
  def upload_pass_valid?
    params[:pass].presence && params[:pass] == Settings::upload_pass
  end
end