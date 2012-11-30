class CreateCachedBroadcastsInfos < ActiveRecord::Migration
  def change
    create_table :cached_broadcasts_infos do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
