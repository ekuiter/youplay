class AddPublishedAtToCachedVideos < ActiveRecord::Migration
  def change
    add_column :cached_videos, :published_at, :datetime
  end
end
