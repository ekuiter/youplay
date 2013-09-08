class RemoveGronkhUrlFromVideos2 < ActiveRecord::Migration
  def change
    remove_column :videos, :gronkh_url
  end
end
