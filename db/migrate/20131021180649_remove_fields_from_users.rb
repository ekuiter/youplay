class RemoveFieldsFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :access_token
    remove_column :users, :refresh_token
    remove_column :users, :expires_in
  end

  def down
    add_column :users, :expires_in, :string
    add_column :users, :refresh_token, :string
    add_column :users, :access_token, :string
  end
end
