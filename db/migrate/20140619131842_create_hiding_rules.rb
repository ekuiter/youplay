class CreateHidingRules < ActiveRecord::Migration
  def change
    create_table :hiding_rules do |t|
      t.integer :user_id
      t.string :pattern
      t.string :channel

      t.timestamps
    end
  end
end
