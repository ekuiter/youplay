class AddUserIdToConfigurations < ActiveRecord::Migration
  def change
    add_column :configurations, :user_id, :integer
  end
end
