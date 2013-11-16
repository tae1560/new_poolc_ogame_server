class Planet < ActiveRecord::Base
  #t.string   "name"
  #t.integer  "player_id"
  #t.string   "coords"
  #t.datetime "created_at"
  #t.datetime "updated_at"
  #t.integer  "moon_id"
  #t.integer  "resource_report_id"
  #t.integer  "fleet_report_id"
  #t.integer  "defense_report_id"
  #t.integer  "building_report_id"

  belongs_to :player
  belongs_to :moon

  has_many :reports

  belongs_to :resource_report, :class_name => "Report"
  belongs_to :fleet_report, :class_name => "Report"
  belongs_to :defense_report, :class_name => "Report"
  belongs_to :building_report, :class_name => "Report"

  def self.crawl
    require 'nokogiri'
    require 'open-uri'

    doc = Nokogiri::XML(open('http://s119-en.ogame.gameforge.com/api/universe.xml'))
    doc.css("planet").each do |planet|
      db_planet = Planet.find_by_id(planet["id"])
      db_planet = Planet.new(:id => planet["id"]) unless db_planet
      db_player = Player.find_by_id(planet["player"])
      if db_player
        db_planet.player = db_player
      end
      db_planet.name = planet["name"]
      db_planet.coords = planet["coords"]

      # player 매핑이 안되는 경우도 있음
      #unless db_planet.player
      #  puts "error : #{planet["player"]}"
      #end

      moon = planet.css("moon").first
      if moon
        db_moon = Moon.find_by_id(moon["id"])
        db_moon = Moon.new(:id => moon["id"]) unless db_moon
        db_planet.moon = db_moon
        db_moon.name = moon["name"]
        db_moon.size = moon["size"]
        db_moon.save!
      end
      db_planet.save!
    end
  end
end
