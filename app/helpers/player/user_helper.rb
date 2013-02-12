module Player
  module UserHelper

    def recently_watched_videos # get recently watched videos
      videos.limit(max_recently_watched).order('created_at DESC').all
    end

  end
end