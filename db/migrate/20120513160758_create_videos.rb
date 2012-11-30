class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :url
      t.string :gronkh_url
      t.string :channel_topic
      t.string :station
      t.string :browser
      t.integer :user_id
      t.timestamps
    end
  end
end
