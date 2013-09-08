class RemoveStationFromVideos < ActiveRecord::Migration
  def change
    remove_column :videos, :station
  end
end
