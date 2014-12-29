module ControllerMixins
  module LogAndStatsController
    private

    def figure_collection(search)
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
      [collection, search]
    end
  end
end
