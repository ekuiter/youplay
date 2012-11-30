class AddFieldsToCachedBroadcast < ActiveRecord::Migration
  def change
    remove_column :cached_broadcasts, :date
    remove_column :cached_broadcasts, :time
    add_column :cached_broadcasts, :published_at, :datetime
  end
end
