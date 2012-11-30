class CreateSubscribedBroadcasts < ActiveRecord::Migration
  def change
    create_table :subscribed_broadcasts do |t|
      t.text :broadcast
      t.integer :user_id
      t.timestamps
    end
  end
end
