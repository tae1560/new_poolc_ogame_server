class CreateMoons < ActiveRecord::Migration
  def change
    create_table :moons do |t|
      t.string :name
      t.integer :size

      t.timestamps
    end

    add_column :planets, :moon_id, :integer, :index => true
  end
end
