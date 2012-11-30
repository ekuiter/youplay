class CreateCachedBroadcasts < ActiveRecord::Migration
  def change
    create_table :cached_broadcasts do |t|
      t.string :station
      t.string :topic
      t.string :title
      t.string :date
      t.string :time
      t.string :url
      t.string :topic_url
      t.string :md5

      t.timestamps
    end
  end
end
