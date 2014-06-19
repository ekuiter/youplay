class Api::LogController < Api::AuthenticatedController
  def index
    @search = params[:search] ? params[:search] : ""
    @collection = if @search == "favorites"
                    current_user.videos.joins(:favorite)
                  elsif not params[:search].blank?
                    current_user.videos.where "title like ?", "%#{params[:search]}%"
                  else
                    current_user.videos
                  end
    log @collection
  end
  
  private
  
  def log(collection)
    results = params[:results] ? params[:results].to_i : 25
    page = params[:page] ? params[:page].to_i : 0
    videos = current_user.pagination collection, results, page
    videos.each do |video|
      begin
        video.channel_topic = YouplayChannel.new(id: video.channel_topic, provider: video.provider.to_sym).fetch.name
      rescue
      end
    end
    render json: videos
  end
end