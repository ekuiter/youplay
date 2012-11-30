class CreateHideBroadcasts < ActiveRecord::Migration
  def change
    create_table :hide_broadcasts do |t|
      t.integer :user_id
      t.integer :cached_broadcast_id
      t.timestamps
    end
  end
end
