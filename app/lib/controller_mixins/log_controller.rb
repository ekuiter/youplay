module ControllerMixins
  module LogController
    private
    
    def search(search)
      search = search ? search.strip : ""
      videos = current_user.videos.includes(:category)
      begin
        collection = if search == "favorites"
          videos.joins(:favorite)
        elsif search.starts_with? "provider:"
          provider = search.gsub("provider:", "").strip
          videos.where provider: provider
        elsif search.starts_with? "channel:"
          channel = search.gsub("channel:", "").strip.split(":")
          result = videos.where provider: channel[0], channel_topic: channel[1]
          if result.blank?
            YouplayProvider.providers.each do |provider|
              begin
                channel_id = YouplayChannel.new(provider: YouplayProvider.new(provider: provider), name: channel[0]).id
                result = videos.where provider: provider, channel_topic: channel_id
                break
              rescue
              end
            end
          end
          result
        elsif search.starts_with? "category:"
          category_id = search.gsub("category:", "").strip.to_i
          category_id = category_id == -1 ? nil : current_user.categories.find(category_id)
          videos.where category_id: category_id
        elsif not search.blank?
          videos.where "title like ?", "%#{search}%"
        else
          videos
        end
      rescue
        collection = videos.none
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
