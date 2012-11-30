class CreateShowBroadcasts < ActiveRecord::Migration
  def change
    create_table :show_broadcasts do |t|
      t.boolean :show
      t.integer :user_id
      t.integer :cached_broadcast_id
      t.timestamps
    end
  end
end
