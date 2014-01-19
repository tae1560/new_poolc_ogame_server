# coding: utf-8
class Report < ActiveRecord::Base

  belongs_to :planet
  belongs_to :moon

  def self.choose_report_text message
    start_index_array = message.enum_for(:scan,/Resources\s*on/).map { Regexp.last_match.begin(0) }
    start_index_array.each do |start_index|
      end_index = message[start_index..message.length].enum_for(:scan,/Attack/).map { Regexp.last_match.begin(0) }.first

      Report.make_report message[start_index, end_index]
      #puts message[start_index, end_index]
      #puts "#{start_index}, #{end_index}"

    end
  end

  def self.make_report message
    # meesage sample
    # Resources on Casaedus [1:173:11] (Player: darkangelaz) at 11-11 21:24:03
    # Resources on Casaedus [1:173:11] (Player: darkangelaz) at 11-11 21:24:03
    # planet_name, coord, player_name, time
    # key : planet_name, coord, player_name
    matched_string = message.match(/Resources on ([^\[]*) \[(\d+:\d+:\d+)\](?:\s*)\(Player: ([^)]*)\)(?:\s*)at (\d+-\d+ \d+:\d+:\d+)/)

    if matched_string
      planet_name = matched_string[1]
      coords = matched_string[2]
      player_name =  matched_string[3]
      time =  matched_string[4]

      #planet = Planet.where(:name => , :system => matched_string[2].to_i, :planet_number => matched_string[3].to_i).first
      #puts "planet_name : #{planet_name}"
      #puts "coords : #{coords}"
      #puts "player_name : #{player_name}"
      new_time = "#{Util.us_year}-#{time}"
      new_datetime = DateTime.parse(new_time)
      #puts "time : #{new_time} #{DateTime.parse(new_time)}"

      #planet = Planet.where(:name => planet_name, :coords => coords).first
      planet = Planet.where(:coords => coords).first
      #puts "planet : #{planet.inspect}"

      # todo 달일 경우에 케이스를 만들어 주어야 함
      unless planet
        puts "planet error"
        return
        puts error
      end

      player = planet.player

      unless player
        player = Player.where(:name => player_name).first
        planet.player = player
        planet.save!
      end

      unless player
        puts "player error"
        puts error
      end

      report = nil
      if planet
        #  report 생성
        # TODO time 에도 indexing
        report = Report.where(:planet_id => planet.id, :time => new_datetime).first
        report = Report.create(:planet_id => planet.id, :time => new_datetime) unless report
      end

      if report
        report.text = message
        report.save!
        report.parse_all
      end

    end
    #puts "matched_string : #{matched_string}"


  end

  def parse_all
    parse_resources

    if self.energy == 0 or self.energy == nil
      self.delete
      return
    end

    link_report "resource"

    #belongs_to :resource_report, :class_name => "Report"
    #belongs_to :fleet_report, :class_name => "Report"
    #belongs_to :defense_report, :class_name => "Report"
    #belongs_to :building_report, :class_name => "Report"

    if self.text.include? "fleets"
      parse_fleets

      link_report "fleet"
    end

    if self.text.include? "Defense"
      parse_defenses

      link_report "defense"
    end

    if self.text.include? "Building"
      parse_buildings

      link_report "building"
    end

    if self.text.include? "Research"
      parse_researches

      report = self.planet.player.research_report
      if report == nil or report.time < self.time
        self.planet.player.research_report = self
        self.planet.player.save!
      end
    end

    puts self.inspect
    self.save!
  end

  def parse_resources
    resources = ["metal", "crystal", "deuterium", "energy"]

    resources.each do |resource|
      parse_key resource, true
    end
  end

  def parse_fleets
    fleets = ["light_fighter", "heavy_fighter", "cruiser", "battleship", "small_cargo", "large_cargo", "colony_ship",
              "battlecruiser", "bomber", "destroyer", "deathstar", "recycler", "espionage_probe", "solar_satellite"]
    fleets.each do |fleet|
      parse_key fleet
    end
  end

  def parse_defenses
    defenses = ["rocket_launcher", "light_laser", "heavy_laser", "gauss_cannon", "ion_cannon", "plasma_turret",
                "small_shield_dome", "large_shield_dome", "anti_ballistic_missiles", "interplanetary_missiles"]
    defenses.each do |defense|
      parse_key defense
    end
  end

  def parse_buildings
    buildings = ["metal_mine", "crystal_mine", "deuterium_synthesizer", "solar_plant", "fusion_reactor", "metal_storage",
                 "crystal_storage", "deuterium_tank", "shielded_metal_den", "underground_crystal_den", "seabed_deuterium_den",
                 "robotics_factory", "shipyard", "research_lab", "alliance_depot", "missile_silo", "nanite_factory",
                 "terraformer", "lunar_base", "sensor_phalanx", "jump_gate"]
    buildings.each do |building|
      parse_key building
    end
  end

  def parse_researches
    researches = ["energy_technology", "laser_technology", "ion_technology", "hyperspace_technology", "plasma_technology",
                  "combustion_drive", "impulse_drive", "hyperspace_drive", "espionage_technology", "computer_technology",
                  "astrophysics", "intergalactic_research_network", "graviton_technology", "weapons_technology",
                  "shielding_technology", "armour_technology"]
    researches.each do |research|
      parse_key research
    end

  end

  def parse_key key, is_resource = false
    matched_string = self.text.match(/#{Util.ogame_camelize key}#{":" if is_resource}(?:\s*)((\d|[.])+)(?:\s*)/)
    if matched_string

      value = matched_string[1].gsub(/[.]/,"").to_i
      #puts "#{key} : #{value}"
      self.send("#{key}=", value)
    else
      self.send("#{key}=", nil)
    end

  end

  def link_report key
    report = self.planet.send("#{key}_report")
    if report == nil or report.time < self.time
      self.planet.send("#{key}_report=", self)
      self.planet.save!
    end
  end

  def self.parse_all
    Report.find_each do |report|
      report.parse_all
    end
  end

end
