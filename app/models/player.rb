class Player < ActiveRecord::Base
  #t.string  :name
  #t.string  :status
  #t.integer :alliance_id
  #t.string  :password

  has_many :planets

  def hashed_password
    return Digest::MD5.hexdigest(self.password) if self.password
    return nil
  end

  def self.crawl
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
end
