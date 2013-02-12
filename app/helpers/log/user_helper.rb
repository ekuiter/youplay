module Log
  module UserHelper

    def watched_videos results, page # get watched videos by results per page and page number
      videos.limit(results).offset(page*results).order('created_at DESC').all
    end

  end
end