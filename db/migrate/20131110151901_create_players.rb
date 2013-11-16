class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      # id, name, status, alliance, password, planets
      t.string  :name
      t.string  :status
      t.integer :alliance_id
      t.string  :password

      t.timestamps
    end
  end
end
