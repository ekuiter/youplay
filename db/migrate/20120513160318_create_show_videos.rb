class CreateShowVideos < ActiveRecord::Migration
  def change
    create_table :show_videos do |t|
      t.boolean :show
      t.integer :user_id
      t.integer :cached_video_id
      t.timestamps
    end
  end
end
