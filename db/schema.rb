# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131110230817) do

  create_table "moons", force: true do |t|
    t.string   "name"
    t.integer  "size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "resource_report_id"
    t.integer  "fleet_report_id"
    t.integer  "defense_report_id"
    t.integer  "building_report_id"
  end

  create_table "planets", force: true do |t|
    t.string   "name"
    t.integer  "player_id"
    t.string   "coords"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "moon_id"
    t.integer  "resource_report_id"
    t.integer  "fleet_report_id"
    t.integer  "defense_report_id"
    t.integer  "building_report_id"
  end

  add_index "planets", ["player_id"], name: "index_planets_on_player_id", using: :btree

  create_table "players", force: true do |t|
    t.string   "name"
    t.string   "status"
    t.integer  "alliance_id"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "research_report_id"
  end

  create_table "reports", force: true do |t|
    t.datetime "time"
    t.text     "text"
    t.integer  "metal"
    t.integer  "crystal"
    t.integer  "deuterium"
    t.integer  "energy"
    t.integer  "light_fighter"
    t.integer  "heavy_fighter"
    t.integer  "cruiser"
    t.integer  "battleship"
    t.integer  "small_cargo"
    t.integer  "large_cargo"
    t.integer  "colony_ship"
    t.integer  "battlecruiser"
    t.integer  "bomber"
    t.integer  "destroyer"
    t.integer  "deathstar"
    t.integer  "recycler"
    t.integer  "espionage_probe"
    t.integer  "solar_satellite"
    t.integer  "rocket_launcher"
    t.integer  "light_laser"
    t.integer  "heavy_laser"
    t.integer  "gauss_cannon"
    t.integer  "ion_cannon"
    t.integer  "plasma_turret"
    t.integer  "small_shield_dome"
    t.integer  "large_shield_dome"
    t.integer  "anti_ballistic_missiles"
    t.integer  "interplanetary_missiles"
    t.integer  "metal_mine"
    t.integer  "crystal_mine"
    t.integer  "deuterium_synthesizer"
    t.integer  "solar_plant"
    t.integer  "fusion_reactor"
    t.integer  "metal_storage"
    t.integer  "crystal_storage"
    t.integer  "deuterium_tank"
    t.integer  "shielded_metal_den"
    t.integer  "underground_crystal_den"
    t.integer  "seabed_deuterium_den"
    t.integer  "robotics_factory"
    t.integer  "shipyard"
    t.integer  "research_lab"
    t.integer  "alliance_depot"
    t.integer  "missile_silo"
    t.integer  "nanite_factory"
    t.integer  "terraformer"
    t.integer  "lunar_base"
    t.integer  "sensor_phalanx"
    t.integer  "jump_gate"
    t.integer  "energy_technology"
    t.integer  "laser_technology"
    t.integer  "ion_technology"
    t.integer  "hyperspace_technology"
    t.integer  "plasma_technology"
    t.integer  "combustion_drive"
    t.integer  "impulse_drive"
    t.integer  "hyperspace_drive"
    t.integer  "espionage_technology"
    t.integer  "computer_technology"
    t.integer  "astrophysics"
    t.integer  "intergalactic_research_network"
    t.integer  "graviton_technology"
    t.integer  "weapons_technology"
    t.integer  "shielding_technology"
    t.integer  "armor_technology"
    t.integer  "planet_id"
    t.integer  "moon_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reports", ["moon_id"], name: "index_reports_on_moon_id", using: :btree
  add_index "reports", ["planet_id"], name: "index_reports_on_planet_id", using: :btree

end
