module ControllerMixins
  module LogController
    private
    
    def search(search)
      search = search ? search : ""
      collection = if search == "favorites"
        current_user.videos.joins(:favorite)
      elsif not search.blank?
        current_user.videos.where "title like ?", "%#{search}%"
      else
        current_user.videos
      end
      [search, collection]
    end
  
    def log(collection, results, page, detailed = false)
      default_number = 50
      @results_range = default_number..400
      @results = results.nil? ? default_number : Integer(results)
      @results = @results_range.min unless @results_range.include? @results
      page = page.nil? ? 0 : Integer(page) - 1
      page = 0 if page < 0
      @videos = current_user.pagination collection, @results, page
      if detailed
        @video_count = collection.count
        @page_count = @video_count / @results + (@video_count % @results == 0 ? 0 : 1)
        @current_page = page + 1
        @favorited_video_ids = current_user.favorites.map {|f| f.video_id}
      end
    end
    
    def videos_with_channel_names(videos)
      YouplayChannel.prefetch_all
      videos.each do |video|
          video.channel_topic = video.youplay_channel.name rescue nil
      end
      videos
    end
  end
end