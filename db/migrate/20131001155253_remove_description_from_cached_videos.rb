class RemoveDescriptionFromCachedVideos < ActiveRecord::Migration
  def up
    remove_column :cached_videos, :description
  end

  def down
    add_column :cached_videos, :description, :string
  end
end
