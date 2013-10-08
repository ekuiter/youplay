module Log
  module UserHelper

    def watched_videos results, page # get watched videos by results per page and page number
      videos.limit(results).offset(page*results).order('created_at DESC').all
    end
    
    def favorited_videos results, page # get watched videos by results per page and page number
      favorites.limit(results).offset(page*results).all.map {|f| f.video}.sort_by {|video| video.created_at}.reverse
    end

  end
end