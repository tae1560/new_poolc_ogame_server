fleets = [{name:"light_fighter", metal:3000, crystal:1000, deuterium:0, attack_ratio:1},
    {name:"heavy_fighter", metal:6000, crystal:4000, deuterium:0, attack_ratio:1},
    {name:"cruiser", metal:20000, crystal:7000, deuterium:2000, attack_ratio:1},
    {name:"battleship", metal:45000, crystal:15000, deuterium:0, attack_ratio:1},
    {name:"small_cargo", metal:2000, crystal:2000, deuterium:0, attack_ratio:0.25},
    {name:"large_cargo", metal:6000, crystal:6000, deuterium:0, attack_ratio:0.25},
    {name:"colony_ship", metal:10000, crystal:20000, deuterium:10000, attack_ratio:0.25},
    {name:"battlecruiser", metal:30000, crystal:40000, deuterium:15000, attack_ratio:1},
    {name:"bomber", metal:50000, crystal:25000, deuterium:15000, attack_ratio:1},
    {name:"destroyer", metal:60000, crystal:50000, deuterium:15000, attack_ratio:1},
    {name:"deathstar", metal:5000000, crystal:4000000, deuterium:1000000, attack_ratio:1},
    {name:"recycler", metal:10000, crystal:6000, deuterium:2000, attack_ratio:0.25},
    {name:"espionage_probe", metal:0, crystal:1000, deuterium:0, attack_ratio:0},
    {name:"solar_satellite", metal:0, crystal:2000, deuterium:500, attack_ratio:0}]

defenses = [{name:"rocket_launcher", metal:2000, crystal:0, deuterium:0},
    {name:"light_laser", metal:1500, crystal:500, deuterium:0},
    {name:"heavy_laser", metal:6000, crystal:2000, deuterium:0},
    {name:"gauss_cannon", metal:20000, crystal:15000, deuterium:2000},
    {name:"ion_cannon", metal:2000, crystal:6000, deuterium:0},
    {name:"plasma_turret", metal:50000, crystal:50000, deuterium:30000},
    {name:"small_shield_dome", metal:10000, crystal:10000, deuterium:0},
    {name:"large_shield_dome", metal:50000, crystal:50000, deuterium:0}]

function planet_setting(planet) {
    var pattern = /(\d+):(\d+):(\d+)/;
    var parsed_string = pattern.exec(planet.coords);
    planet.galaxy = parsed_string[1];
    planet.system = parsed_string[2];
    planet.position = parsed_string[3];
    planet.resource_metal = planet.resource_report.metal;
    planet.resource_crystal = planet.resource_report.crystal;
    planet.resource_deuterium = planet.resource_report.deuterium;
    planet.resource = planet.resource_report.metal + planet.resource_report.crystal + planet.resource_report.deuterium;
    planet.number_of_small_cargo = Math.ceil(planet.resource/2/5000);
    planet.number_of_large_cargo = Math.ceil(planet.resource/2/5000/5);
    planet.attack_address = "http://s119-en.ogame.gameforge.com/game/index.php?page=fleet1&galaxy="+planet.galaxy+"&system="+planet.system+"&position="+planet.position+"&type=1&mission=1&am203="+planet.number_of_large_cargo;
    planet.galaxy_address = "http://s119-en.ogame.gameforge.com/game/index.php?page=galaxy&no_header=1&galaxy="+planet.galaxy+"&system="+planet.system+"&planet="+planet.position

    planet.debris = 0;
    planet.debris_metal = 0;
    planet.debris_crystal = 0;
    planet.attack_fleet_score = 0;

    if(planet.fleet_report) {
        planet.number_of_fleets = 0;

        _.each(fleets, function(fleet) {
            if(planet.fleet_report[fleet.name]) {
                planet.number_of_fleets += planet.fleet_report[fleet.name];
                planet.debris_metal += planet.fleet_report[fleet.name] * fleet.metal;
                planet.debris_crystal += planet.fleet_report[fleet.name] * fleet.crystal;
                planet.attack_fleet_score += planet.fleet_report[fleet.name] * (fleet.metal + fleet.crystal + fleet.deuterium) * fleet.attack_ratio;
            }
        });
    } else {
        planet.number_of_fleets = "-";
    }

    if(planet.defense_report) {
        planet.number_of_defenses = 0;

        _.each(defenses, function(defense) {
            if(planet.defense_report[defense.name]) {
                planet.number_of_defenses += planet.defense_report[defense.name];
                planet.debris_metal += planet.defense_report[defense.name] * defense.metal;
                planet.debris_crystal += planet.defense_report[defense.name] * defense.crystal;
            }
        });
    } else {
        planet.number_of_defenses = "-";
    }

    planet.debris_metal *= 0.3;
    planet.debris_crystal *= 0.3;
    planet.debris = planet.debris_metal + planet.debris_crystal;
    planet.number_of_recycler = Math.ceil(planet.debris/20000);
    planet.resource_debris = planet.resource + planet.debris;
}

function planetIndexCtrl($scope, $http) {

    $scope.loding = "loding";

    $scope.filter_time_diff = 7200;

    $http.get('/planets.json').success(function(data) {
        $scope.planets = data;

        _.each($scope.planets, $scope.init_planet);
        $scope.filter_with_position();

        $scope.loding = "";

//        $scope.init_planet(planet);
    });

    $scope.filter_planets = function(){
        $scope.filtered_planets = _.filter($scope.planets, function(planet){ return planet.time_diff < $scope.filter_time_diff; });
    }

    $scope.filter_position = "";

    $scope.filter_with_position = function() {
        if($scope.filter_position.length > 0) {
//            $scope.filtered_planets = _.filter($scope.planets, function(planet){ return planet.coords == $scope.filter_position; });
            $scope.filtered_planets = _.filter($scope.planets, function(planet){ return planet.coords.indexOf($scope.filter_position) !== -1; });
        } else {
            $scope.filter_planets();
        }
    }
    
    $scope.filter_player_name = "";
    
    $scope.filter_with_playername = function() {
        if($scope.filter_player_name.length > 0) {
            $scope.filtered_planets = _.filter($scope.planets, function(planet){ return planet.player.name.indexOf($scope.filter_player_name) !== -1;});
        } else {
            $scope.filter_planets();
        }
        
    }

    $scope.class_of_row = function(index) {
        if (index % 2 == 1) return "odd";
        else return null;
    };

    $scope.init_planet = function(planet) {

        planet_setting(planet);

        $scope.update_planet_time(planet);


    };

    $scope.orderProp = "-resource";

    $scope.setOrderProp = function(prop) {
        if($scope.orderProp == prop) $scope.orderProp = "-" + prop;
        else $scope.orderProp = prop;
    }

    $scope.scheduler = function() {
        _.each($scope.planets, $scope.update_planet_time);
        $scope.$apply();
    }

    a = 0;
    $scope.update_planet_time = function(planet) {
//        alert("test")
//        planet.resource = 0;
        seconds = parseInt((new Date() - new Date(planet.resource_report.time)) / 1000);

        planet.time_diff = seconds;

        minutes = parseInt(seconds / 60);
        seconds = seconds % 60;
        hours = parseInt(minutes / 60);
        minutes = minutes % 60;

        str = ""
        if (hours > 0) str += hours + "시간 ";
        str += minutes + "분 ";
        planet.time_diff_str = str
//        planet.time_diff_str = str + seconds + "초 전";
//        planet.time_diff = a++;
    }

    $scope.customFilter = function() {
       return function(input) {
           return output;
       }
    };

    setInterval($scope.scheduler, 1000);
//    setInterval(function(){alert("Hello")},3000);

}


function planetShowCtrl($scope, $location, $http) {
    splitUrlArray = $location.absUrl().split('/')
    $scope.id = splitUrlArray[splitUrlArray.length - 1];

    $scope.loading = "loading";

    $http.get('/planets/'+ $scope.id +'.json').success(function(data) {
        $scope.planet = data;

        $scope.init_planet($scope.planet);
//        _.each($scope.planets, $scope.init_planet);

//        $scope.planets = _.filter($scope.planets, function(planet){ return planet.time_diff < 36000; });




//        $scope.init_planet(planet);
    });

    $scope.init_planet = function(planet) {
        planet_setting(planet);
        $scope.update_planet_time(planet);
    };

    $scope.update_planet_time = function(planet) {
//        alert("test")
//        planet.resource = 0;
        seconds = parseInt((new Date() - new Date(planet.resource_report.time)) / 1000);

        planet.time_diff = seconds;
        planet.time_diff_str = $scope.calculate_time_string(planet.resource_report.time);
//        planet.time_diff_str = str + seconds + "초 전";
//        planet.time_diff = a++;
    };

    $scope.calculate_time_string = function(time) {
        seconds = parseInt((new Date() - new Date(time)) / 1000);

        minutes = parseInt(seconds / 60);
        seconds = seconds % 60;
        hours = parseInt(minutes / 60);
        minutes = minutes % 60;

        str = ""
        if (hours > 0) str += hours + "시간 ";
        str += minutes + "분 전 업데이트";
        return str;
    }

    $scope.resource_report_field = ["metal","crystal","deuterium","energy"];
    $scope.fleet_report_field = ["light_fighter", "heavy_fighter", "cruiser", "battleship", "small_cargo", "large_cargo", "colony_ship",
        "battlecruiser", "bomber", "destroyer", "deathstar", "recycler", "espionage_probe", "solar_satellite"];
    $scope.defense_report_field = ["rocket_launcher", "light_laser", "heavy_laser", "gauss_cannon", "ion_cannon", "plasma_turret",
        "small_shield_dome", "large_shield_dome", "anti_ballistic_missiles", "interplanetary_missiles"];
    $scope.building_report_field = ["metal_mine", "crystal_mine", "deuterium_synthesizer", "solar_plant", "fusion_reactor", "metal_storage",
        "crystal_storage", "deuterium_tank", "shielded_metal_den", "underground_crystal_den", "seabed_deuterium_den",
        "robotics_factory", "shipyard", "research_lab", "alliance_depot", "missile_silo", "nanite_factory",
        "terraformer", "lunar_base", "sensor_phalanx", "jump_gate"];
        $scope.research_report_field = ["energy_technology", "laser_technology", "ion_technology", "hyperspace_technology", "plasma_technology",
        "combustion_drive", "impulse_drive", "hyperspace_drive", "espionage_technology", "computer_technology",
        "astrophysics", "intergalactic_research_network", "graviton_technology", "weapons_technology",
        "shielding_technology", "armour_technology"];

}
