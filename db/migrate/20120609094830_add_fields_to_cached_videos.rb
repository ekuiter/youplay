class AddFieldsToCachedVideos < ActiveRecord::Migration
  def change
    remove_column :cached_videos, :published_at
    add_column :cached_videos, :uploaded_at, :datetime
  end
end
