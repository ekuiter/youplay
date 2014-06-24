class Api::LogController < Api::AuthenticatedController
  include ControllerMixins::LogController
  
  def index
    @search, @collection = search(params[:search])
    log @collection, params[:results], params[:page]
    render json: videos_with_channel_names(@videos)
  end
end