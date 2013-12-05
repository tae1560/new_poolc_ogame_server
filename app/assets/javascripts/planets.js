function planetIndexCtrl($scope, $http) {

    $scope.loding = "loding";

    $scope.filter_time_diff = 7200;

    $http.get('/planets.json').success(function(data) {
        $scope.planets = data;

        _.each($scope.planets, $scope.init_planet);
        $scope.filter_planets();

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

    $scope.class_of_row = function(index) {
        if (index % 2 == 1) return "odd";
        else return null;
    };

    $scope.init_planet = function(planet) {
        var pattern = /(\d+):(\d+):(\d+)/;
        var parsed_string = pattern.exec(planet.coords);
        planet.galaxy = parsed_string[1];
        planet.system = parsed_string[2];
        planet.position = parsed_string[3];
        planet.resource = planet.resource_report.metal + planet.resource_report.crystal + planet.resource_report.deuterium;
        planet.number_of_small_cargo = Math.ceil(planet.resource/2/5000);
        planet.number_of_large_cargo = Math.ceil(planet.resource/2/5000/5);
        planet.attack_address = "http://s119-en.ogame.gameforge.com/game/index.php?page=fleet1&galaxy="+planet.galaxy+"&system="+planet.system+"&position="+planet.position+"&type=1&mission=1&am203="+planet.number_of_large_cargo;
        $scope.update_planet_time(planet);

        if(planet.fleet_report) {
            planet.number_of_fleets = 0;

            fleets = ["light_fighter", "heavy_fighter", "cruiser", "battleship", "small_cargo", "large_cargo", "colony_ship",
                "battlecruiser", "bomber", "destroyer", "deathstar", "recycler", "espionage_probe", "solar_satellite"]

            _.each(fleets, function(fleet) {
                if(planet.fleet_report[fleet]) planet.number_of_fleets += planet.fleet_report[fleet];
            });
        } else {
            planet.number_of_fleets = "-";
        }

        if(planet.defense_report) {
            planet.number_of_defenses = 0;

            defenses = ["rocket_launcher", "light_laser", "heavy_laser", "gauss_cannon", "ion_cannon", "plasma_turret",
                "small_shield_dome", "large_shield_dome"]

            _.each(defenses, function(defense) {
                if(planet.defense_report[defense]) planet.number_of_defenses += planet.defense_report[defense];
            });
        } else {
            planet.number_of_defenses = "-";
        }
    };

    $scope.orderProp = "-resource";

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

    $scope.planet = "loading";

    $http.get('/planets/'+ $scope.id +'.json').success(function(data) {
        $scope.planet = data;

        $scope.init_planet($scope.planet);
//        _.each($scope.planets, $scope.init_planet);

//        $scope.planets = _.filter($scope.planets, function(planet){ return planet.time_diff < 36000; });




//        $scope.init_planet(planet);
    });

    $scope.init_planet = function(planet) {
        var pattern = /(\d+):(\d+):(\d+)/;
        var parsed_string = pattern.exec(planet.coords);
        planet.galaxy = parsed_string[1];
        planet.system = parsed_string[2];
        planet.position = parsed_string[3];
        planet.resource = planet.resource_report.metal + planet.resource_report.crystal + planet.resource_report.deuterium;
        planet.number_of_small_cargo = Math.ceil(planet.resource/2/5000);
        planet.number_of_large_cargo = Math.ceil(planet.resource/2/5000/5);
        planet.attack_address = "http://s119-en.ogame.gameforge.com/game/index.php?page=fleet1&galaxy="+planet.galaxy+"&system="+planet.system+"&position="+planet.position+"&type=1&mission=1&am203="+planet.number_of_large_cargo;
        $scope.update_planet_time(planet);

        if(planet.fleet_report) {
            planet.number_of_fleets = 0;

            fleets = ["light_fighter", "heavy_fighter", "cruiser", "battleship", "small_cargo", "large_cargo", "colony_ship",
                "battlecruiser", "bomber", "destroyer", "deathstar", "recycler", "espionage_probe", "solar_satellite"]

            _.each(fleets, function(fleet) {
                if(planet.fleet_report[fleet]) planet.number_of_fleets += planet.fleet_report[fleet];
            });
        } else {
            planet.number_of_fleets = "-";
        }

        if(planet.defense_report) {
            planet.number_of_defenses = 0;

            defenses = ["rocket_launcher", "light_laser", "heavy_laser", "gauss_cannon", "ion_cannon", "plasma_turret",
                "small_shield_dome", "large_shield_dome"]

            _.each(defenses, function(defense) {
                if(planet.defense_report[defense]) planet.number_of_defenses += planet.defense_report[defense];
            });
        } else {
            planet.number_of_defenses = "-";
        }
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