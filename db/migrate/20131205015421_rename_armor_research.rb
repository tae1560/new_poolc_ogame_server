class RenameArmorResearch < ActiveRecord::Migration
  def change
    rename_column(:reports, :armor_technology, :armour_technology)
  end
end
