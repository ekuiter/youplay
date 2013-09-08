class AddChannelToHideVideos < ActiveRecord::Migration
  def change
    add_column :hide_videos, :channel, :string
  end
end
