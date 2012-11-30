class CreateConfigurations < ActiveRecord::Migration
  def change
    create_table :configurations do |t|
      t.string :feature
      t.string :value

      t.timestamps
    end
  end
end
