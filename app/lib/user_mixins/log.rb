module UserMixins
  module Log
    def pagination collection, results, page # get watched videos by results per page and page number
      collection.limit(results).offset(page*results).order('videos.created_at DESC').all
    end
  end
end
