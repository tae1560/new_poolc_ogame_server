class CreatePlanets < ActiveRecord::Migration
  def change
    create_table :planets do |t|
      t.string :name
      t.belongs_to :player
      t.string :name
      t.string :coords

      t.timestamps
    end

    add_index :planets, :player_id
  end
end
