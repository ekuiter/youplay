class AddProviderToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :provider, :string
  end
end
