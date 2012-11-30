class CreateCachedVideos < ActiveRecord::Migration
  def change
    create_table :cached_videos do |t|
      t.string :title
      t.string :url
      t.string :channel
      t.string :description

      t.timestamps
    end
  end
end
