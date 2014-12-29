module ControllerMixins
  module LogAndStatsController
    private

    def figure_collection(search)
      search = search ? search.strip : ""
      videos = current_user.videos.includes(:category)
      begin
        search_type, collection = if search == "favorites"
          [:favorites, videos.joins(:favorite)]
        elsif search.starts_with? "provider:"
          provider = search.gsub("provider:", "").strip
          [:provider, videos.where(provider: provider)]
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
          [:channel, result]
        elsif search.starts_with? "category:"
          category = search.gsub("category:", "").strip
          category_id = category.to_i
          begin
            category_id = category_id == -1 ? nil : current_user.categories.find(category_id)
            [:category, videos.where(category_id: category_id)]
          rescue
            category = current_user.categories.find_by_name(category)
            [:category, videos.where(category_id: category.id)] if category
          end
        elsif search.starts_with? "browser:"
          browser = search.gsub("browser:", "").strip
          [:browser, videos.where(browser: browser)]
        elsif not search.blank?
          [:search, videos.where("title like ?", "%#{search}%")]
        else
          [:all_videos, videos]
        end
      rescue
         search_type, collection = :invalid, videos.none
      end
      search_type = :invalid if search_type.blank?
      [collection, search, search_type]
    end
  end
end
