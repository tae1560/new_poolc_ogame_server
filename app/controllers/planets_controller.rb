class PlanetsController < ApplicationController
  def index


    respond_to do |format|
      format.json {
        @planets = Planet.where("resource_report_id IS NOT NULL").all
        render json: @planets.to_json(:include => [:resource_report, :fleet_report, :defense_report, :building_report, :player])
      }
      format.html {
        #@planet_rows = []
        #@planets.each do |planet|
        #  planet_row = {}
        #  planet_row[:coords] = planet.coords
        #  planet_row[:metal] = planet.resource_report.metal
        #  planet_row[:crystal] = planet.resource_report.crystal
        #  planet_row[:deuterium] = planet.resource_report.deuterium
        #  planet_row[:resource] = planet_row[:metal] + planet_row[:crystal] + planet_row[:deuterium]
        #  planet_row[:cargo] = planet_row[:resource] / 2 / 5000
        #
        #  if planet.fleet_report
        #    planet_row[:number_of_fleets] = 0
        #    fleets = ["light_fighter", "heavy_fighter", "cruiser", "battleship", "small_cargo", "large_cargo", "colony_ship",
        #              "battlecruiser", "bomber", "destroyer", "deathstar", "recycler", "espionage_probe", "solar_satellite"]
        #
        #    fleets.each do |fleet|
        #      planet_row[:number_of_fleets] += planet.fleet_report.send(fleet) if planet.fleet_report.send(fleet)
        #    end
        #  end
        #
        #  if planet.defense_report
        #    planet_row[:number_of_defenses] = 0
        #    defenses = ["rocket_launcher", "light_laser", "heavy_laser", "gauss_cannon", "ion_cannon", "plasma_turret",
        #                "small_shield_dome", "large_shield_dome", "anti_ballistic_missiles", "interplanetary_missiles"]
        #
        #    defenses.each do |defense|
        #      planet_row[:number_of_defenses] += planet.defense_report.send(defense) if planet.defense_report.send(defense)
        #    end
        #  end
        #
        #  matched_string = planet.coords.match(/(\d+):(\d+):(\d+)/)
        #  if matched_string
        #    planet_row[:attack_address] = "http://s119-en.ogame.gameforge.com/game/index.php?page=fleet1&galaxy=#{matched_string[1]}&system=#{matched_string[2]}&position=#{matched_string[3]}&type=1&mission=1&am202=#{planet_row[:cargo]}"
        #  end
        #
        #  @planet_rows.push planet_row
        #end
        #
        #@planet_rows.sort_by! { |k| -k[:resource]}
      }
    end

  end
end
