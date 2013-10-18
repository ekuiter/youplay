class AddProviderToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :provider, :string
  end
end
