namespace :crawler do
  task :player => :environment do

    require 'nokogiri'
    require 'open-uri'

    doc = Nokogiri::XML(open('http://s119-en.ogame.gameforge.com/api/players.xml'))
    doc.css("player").each do |player|
      db_player = Player.find_by_id(player["id"])
      db_player = Player.new(:id => player["id"]) unless db_player
      db_player.name = player["name"]
      db_player.status = player["status"]
      db_player.alliance_id = player["alliance_id"]

      db_player.save!
    end
  end

  task :planet => :environment do
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
