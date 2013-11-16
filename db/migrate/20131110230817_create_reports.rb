class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.datetime :time
      t.text :text

      # resources
      t.integer :metal
      t.integer :crystal
      t.integer :deuterium
      t.integer :energy

      # fleets
      t.integer :light_fighter
      t.integer :heavy_fighter
      t.integer :cruiser
      t.integer :battleship
      t.integer :small_cargo
      t.integer :large_cargo
      t.integer :colony_ship
      t.integer :battlecruiser
      t.integer :bomber
      t.integer :destroyer
      t.integer :deathstar
      t.integer :recycler
      t.integer :espionage_probe
      t.integer :solar_satellite

      # defense
      t.integer :rocket_launcher
      t.integer :light_laser
      t.integer :heavy_laser
      t.integer :gauss_cannon
      t.integer :ion_cannon
      t.integer :plasma_turret
      t.integer :small_shield_dome
      t.integer :large_shield_dome
      t.integer :anti_ballistic_missiles
      t.integer :interplanetary_missiles

      # building
      t.integer :metal_mine
      t.integer :crystal_mine
      t.integer :deuterium_synthesizer
      t.integer :solar_plant
      t.integer :fusion_reactor
      t.integer :metal_storage
      t.integer :crystal_storage
      t.integer :deuterium_tank
      t.integer :fusion_reactor
      t.integer :shielded_metal_den
      t.integer :underground_crystal_den
      t.integer :seabed_deuterium_den
      t.integer :robotics_factory
      t.integer :shipyard
      t.integer :research_lab
      t.integer :alliance_depot
      t.integer :missile_silo
      t.integer :nanite_factory
      t.integer :terraformer
      t.integer :lunar_base
      t.integer :sensor_phalanx
      t.integer :jump_gate

      # research
      t.integer :energy_technology
      t.integer :laser_technology
      t.integer :ion_technology
      t.integer :hyperspace_technology
      t.integer :plasma_technology
      t.integer :combustion_drive
      t.integer :impulse_drive
      t.integer :hyperspace_drive
      t.integer :espionage_technology
      t.integer :computer_technology
      t.integer :astrophysics
      t.integer :intergalactic_research_network
      t.integer :graviton_technology
      t.integer :weapons_technology
      t.integer :shielding_technology
      t.integer :armor_technology

      # relation
      t.belongs_to :planet, :index => true
      t.belongs_to :moon, :index => true

      t.timestamps
    end

    # planet or moon - report
    add_column :planets, :resource_report_id, :integer, :index => true
    add_column :planets, :fleet_report_id, :integer, :index => true
    add_column :planets, :defense_report_id, :integer, :index => true
    add_column :planets, :building_report_id, :integer, :index => true

    add_column :moons, :resource_report_id, :integer, :index => true
    add_column :moons, :fleet_report_id, :integer, :index => true
    add_column :moons, :defense_report_id, :integer, :index => true
    add_column :moons, :building_report_id, :integer, :index => true

    # user - report
    add_column :players, :research_report_id, :integer, :index => true
  end
end
