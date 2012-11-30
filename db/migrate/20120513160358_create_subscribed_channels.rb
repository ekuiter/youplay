class CreateSubscribedChannels < ActiveRecord::Migration
  def change
    create_table :subscribed_channels do |t|
      t.string :channel
      t.integer :user_id
      t.timestamps
    end
  end
end
