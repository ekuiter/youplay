class RemoveFieldsFromCachedBroadcasts < ActiveRecord::Migration
  def up
    remove_column :cached_broadcasts, :created_at
    remove_column :cached_broadcasts, :updated_at
  end

  def down
    add_column :cached_broadcasts, :updated_at, :datetime
    add_column :cached_broadcasts, :created_at, :datetime
  end
end
