class Api::ApiController < ActionController::Base
  respond_to :json
  around_filter :error_handler if Rails.env.production?
  
  private
  
  def error_handler
    begin
      yield
    rescue Exception => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end