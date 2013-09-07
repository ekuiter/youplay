class DropCachedBroadcasts < ActiveRecord::Migration
  def change
    drop_table :cached_broadcasts
    drop_table :cached_broadcasts_infos
    drop_table :hide_broadcasts
    drop_table :subscribed_broadcasts
  end
end
