class CreateHideVideos < ActiveRecord::Migration
  def change
    create_table :hide_videos do |t|
      t.integer :user_id
      t.integer :cached_video_id
      t.timestamps
    end
  end
end
