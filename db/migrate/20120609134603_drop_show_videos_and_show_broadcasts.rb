class DropShowVideosAndShowBroadcasts < ActiveRecord::Migration
  def change
    drop_table :show_videos
    drop_table :show_broadcasts
  end
end
