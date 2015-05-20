module ControllerMixins
  module LogAndStatsController
    private

    def figure_collection(search)
      search = search ? search.strip : ""
      videos = current_user.videos.includes(:category)
      begin
        search_type, collection, search_subject = if search == "favorites"
          [:favorites, videos.joins(:favorite)]
        elsif search.starts_with? "provider:"
          provider = search.gsub("provider:", "").strip
          [:provider, videos.where(provider: provider), YouplayProvider.new(provider: provider.to_sym).name]
        elsif search.starts_with? "channel:"
          channel = search.gsub("channel:", "").strip.split(":")
          result = videos.where provider: channel[0], channel_topic: channel[1]
          youplay_channel = nil
          if result.blank? and channel[1].blank?
            YouplayProvider.providers.each do |provider|
              begin
                youplay_channel = YouplayChannel.new(provider: YouplayProvider.new(provider: provider), name: channel[0])
                result = videos.where provider: provider, channel_topic: youplay_channel.id
                break
              rescue
              end
            end
          else
            youplay_channel = YouplayChannel.new(provider: YouplayProvider.new(provider: channel[0]), id: channel[1])
          end
          [:channel, result, youplay_channel.name]
        elsif search.starts_with? "category:"
          category = search.gsub("category:", "").strip
          category_id = category.to_i
          if category_id == -1
            [:category, videos.where(category_id: nil), I18n.t("stats.no_category")]
          else
            youplay_category = begin
              current_user.categories.find(category_id)
            rescue
              current_user.categories.find_by_name(category)
            end
            raise if youplay_category.blank?
            [:category, videos.where(category_id: youplay_category.id), youplay_category.name]
          end
        elsif search.starts_with? "series:"
          series = search.gsub("series:", "").strip
          [:series, videos.where("title like ?", "#{series}%"), series]
        elsif search.starts_with? "browser:"
          browser = search.gsub("browser:", "").strip
          [:browser, videos.where(browser: browser), browser]
        elsif not search.blank?
          [:search, videos.where("title like ?", "%#{search}%"), search]
        else
          [:all_videos, videos]
        end
      rescue
         search_type, collection, search_subject = :invalid, videos.none, nil
      end
      search_type = :invalid if search_type.blank?
      [collection, search, search_type, search_subject]
    end
  end
end
