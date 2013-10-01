/* 
AMBIENT CIVILIAN TRAFFIC SCRIPT - SP/MP CLIENT COMPATIBLE
Author: tpw 
Date: 20130925
Version: 1.17

	- This script will gradually spawn civilian traffic, up to a maximum specified, onto roads within a specified radius of the player.
	- Cars will then drive, with a specified number of waypoints.
	- If a civilian driver is killed or car damaged another will spawn.
	- Cars are removed if more than the specified radius from the player.
	- Cars will not spawn if player is within a specified radius of an exclusion object (up to 10 objects)
	- Cars may be commandeered
	- Cars spawn with random fuel levels

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works.     

To use: 
1 - Save this script into your mission directory as eg tpw_cars.sqf
2 - Call it with 0 = [5,1000,15,2] execvm "tpw_cars.sqf"; where 5 = start delay, 1000 = radius, 15 = number of waypoints, 2 = max cars

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS
*/

if (isDedicated) exitWith {};
if (count _this < 4) exitwith {hint "TPW CARS incorrect/no config, exiting."};
if (_this select 3 == 0) exitwith {};
if !(isnil "tpw_car_active") exitwith {hint "TPW CARS already running."};
WaitUntil {!isNull FindDisplay 46};

private ["_civlist","_clothes","_houses","_carlist","_sqname","_centerC"];

// READ IN VARIABLES
tpw_car_sleep = _this select 0;
tpw_car_radius = _this select 1;
tpw_car_waypoints = _this select 2;
tpw_car_num = _this select 3;

// DEFAULT VALUES IF MP
if (isMultiplayer) then 
	{
	tpw_car_sleep = 5;
	tpw_car_radius = 1000;
	tpw_car_waypoints = 15;
	tpw_car_num =2;
	};
	
// VARIABLES
_civlist = [
"C_man_p_beggar_F",
"C_man_1",
"C_man_polo_1_F",
"C_man_polo_2_F",
"C_man_polo_3_F",
"C_man_polo_4_F",
"C_man_polo_5_F",
"C_man_polo_6_F",
"C_man_shorts_1_F",
"C_man_1_1_F",
"C_man_1_2_F",
"C_man_1_3_F",
"C_man_p_fugitive_F",
"C_man_p_shorts_1_F",
"C_man_hunter_1_F",
"C_man_shorts_2_F",
"C_man_shorts_3_F",
"C_man_shorts_4_F"
];

_carlist = [
"C_Van_01_box_F",
"C_Van_01_transport_F",
"C_Hatchback_01_F",
"C_Van_01_fuel_F",
"C_Offroad_01_F",
"C_Quadbike_01_F",
"C_SUV_01_F"
]; 
_clothes = [
"U_Competitor",
"U_C_HunterBody_grn",
"U_C_Poloshirt_blue",
"U_C_Poloshirt_burgundy",
"U_C_Poloshirt_redwhite",
"U_C_Poloshirt_salmon",
"U_C_Poloshirt_stripped",
"U_C_Poloshirt_tricolour",
"U_C_Poor_1",
"U_C_Poor_2",
"U_IG_Guerilla2_2",
"U_IG_Guerilla2_3",
"U_IG_Guerilla3_1",
"U_IG_Guerilla3_2",
"U_NikosBody",
"U_Rangemaster"];

tpw_car_cararray = []; // array holding spawned cars
tpw_car_farroads = []; // roads > 250m from unit
tpw_car_roadlist = []; // roads near unit
tpw_car_debug = false; // Car counter
tpw_car_radius_orig = tpw_car_radius; // Original radius to reset to after exclusion
tpw_car_exclude = false; // Is player near car exclusion zone?
tpw_car_mindist = 100; // Car won't be removed if closer than this to player
tpw_car_slowdist = 150; // Car will slow down if this close to the player
tpw_car_spawndist = 250; // Cars will be spawned further than this distance from player
tpw_car_active = true; // Global activate/deactivate
tpw_car_version = 1.17; // Version string

// DELAY	
sleep tpw_car_sleep;	

// CREATE AI CENTRE
_centerC = createCenter civilian;

// DELETE CAR OCCUPANTS AND WAYPOINTS
tpw_car_fnc_delete =
	{
	private ["_grp"];
	_grp = _this select 0;
	// Remove waypoints
	while {(count (waypoints _grp)) > 0} do
		{
		deleteWaypoint ((waypoints _grp) select 0);
		};
	
	// Delete occupants
		{
		deletevehicle _x;
		} foreach units _grp;	

	// Delete occupant group		
	deletegroup _grp;
	};

// WAYPOINTS 
tpw_car_fnc_waypoint = 
	{
	private ["_grp","_road","_wp"];
	//Pick random road
	_grp = _this select 0;
	_road = tpw_car_roadlist select (floor (random (count tpw_car_roadlist)));
	_wp = getposasl _road; 
	_grp addWaypoint [_wp, 0];
	};

// SPAWN CIV/CAR INTO EMPTY GROUP
tpw_car_fnc_carspawn =
	{
	private ["_civtype","_driver","_car","_roadseg","_spawnpos","_spawndir","_i","_ct","_sqname"];

	// Pick a random road segment to spawn car
	[] call tpw_car_fnc_roadpos;
	if (count tpw_car_roadlist < 100) exitwith {};
	_roadseg = tpw_car_farroads select (floor (random (count tpw_car_farroads)));
	_spawnpos = getposasl _roadseg;
	_spawndir = getdir _roadseg;
	_car = _carlist select (floor (random (count _carlist)));
	 _sqname = creategroup civilian;
	_spawncar = _car createVehicle _spawnpos;
	_spawncar setdir _spawndir; 
	_spawncar setfuel random 0.5;
	
	//Driver
	_civtype = _civlist select (floor (random (count _civlist)));
	_driver = _sqname createUnit [_civtype,_spawnpos, [], 0, "FORM"]; 
	_driver moveindriver _spawncar;
	_driver setbehaviour "CARELESS";	
	removeUniform _driver;
	_driver addUniform (_clothes select  (floor (random (count _clothes)))); 
	_driver addeventhandler ["Hit",{_this call tpw_civ_fnc_casualty}];
	_driver addeventhandler ["Killed",{_this call tpw_civ_fnc_casualty}];
	
	//Passenger
	if (random 10 < 5) then 
		{
		_civtype = _civlist select (floor (random (count _civlist)));
		_passenger = _sqname createUnit [_civtype,_spawnpos, [], 0, "FORM"]; 
		_passenger moveincargo _spawncar;
		_passenger setbehaviour "CARELESS";	
		removeUniform _passenger;
		_passenger addUniform (_clothes select  (floor (random (count _clothes)))); 
		_passenger addeventhandler ["Hit",{_this call tpw_civ_fnc_casualty}];
		_passenger addeventhandler ["Killed",{_this call tpw_civ_fnc_casualty}];
		};
	
	//Set variables 
	_spawncar setvariable ["tpw_car_owner", [player],true];
	_spawncar setvariable ["tpw_car_occupants",_sqname,true];

	//Add ability to commandeer car
	_spawncar addaction 
		[
		"Commandeer Vehicle",
			{
			private ["_car","_grp"];
			_car = _this select 0;
			_grp = _car getvariable "tpw_car_occupants";
			
			// Occupants out of car	
				{
				unassignvehicle _x;
				} foreach units _grp;
			
			// Delete occupants if far enough away
			[_grp] spawn 
				{
				private ["_grp","_unit"];
				_grp = _this select 0;
				_unit = (units _grp) select 0;
				waituntil
					{
					sleep 2;
					(_unit distance player > 100);
					};
				[_grp] call tpw_car_fnc_delete;	
				};
			
			// Remove menu item
			_car removeaction 0;
		
			// Remove car from player's car array (it can no longer be despawned)
			tpw_car_cararray = tpw_car_cararray - [_this select 0];
			}
		];

	//Add car to the array of spawned cars
	tpw_car_cararray set [count tpw_car_cararray,_spawncar];

	//Assign waypoints
	for "_i" from 1 to tpw_car_waypoints do
		{
		0 = [_sqname] call tpw_car_fnc_waypoint; 
		};
	[_sqname, (tpw_car_waypoints - 1)] setWaypointType "CYCLE";
	};
    
// SEE IF ANY CARS OWNED BY OTHER PLAYERS ARE WITHIN RANGE, WHICH CAN BE USED INSTEAD OF SPAWNING A NEW CIV
tpw_car_fnc_nearcar =
	{
	private ["_owner","_nearcars","_shareflag"];
	_shareflag = 0;
	if (isMultiplayer) then 
		{
		// Array of near cars
		_nearcars = (position player) nearEntities [["Car"], tpw_car_radius];

		// Live units within range
		{    
		if (_x distance vehicle player < tpw_car_radius && alive _x) then   
			{
			_owner = _x getvariable ["tpw_car_owner",[]];

			//Units with owners, but not this player
			if ((count _owner > 0) && !(player in _owner)) exitwith
				{
				_shareflag = 1;
				_owner set [count _owner,player]; // add player as another owner of this car
				_x setvariable ["tpw_car_owner",_owner,true]; // update ownership
				tpw_car_cararray set [count tpw_car_cararray,_x]; // add this car to the array of cars for this player
				};
			} 
		} foreach _nearcars;   
		};
	//Otherwise, spawn a new car
	if (_shareflag == 0) then 
		{
		[] call tpw_car_fnc_carspawn;    
		};
	};        
	
// POOL OF ROAD POSTIONS NEAR PLAYER
tpw_car_fnc_roadpos = 
	{ 
	tpw_car_roadlist = (position player) nearRoads tpw_car_radius;
	tpw_car_farroads = [];
		{
		if (vehicle player distance position _x > tpw_car_spawndist) then 
			{
			tpw_car_farroads set [count tpw_car_farroads,_x];
			};
		} foreach tpw_car_roadlist;

	// Refresh array of exclusion objects
	tpw_car_excarray = [];
	tpw_car_exclude = false;	
	if !(isnil "tpwcarexc") then {tpw_car_excarray set [count tpw_car_excarray,tpwcarexc]};
	if !(isnil "tpwcarexc_1") then {tpw_car_excarray set [count tpw_car_excarray,tpwcarexc_1]};	
	if !(isnil "tpwcarexc_2") then {tpw_car_excarray set [count tpw_car_excarray,tpwcarexc_2]};
	if !(isnil "tpwcarexc_3") then {tpw_car_excarray set [count tpw_car_excarray,tpwcarexc_3]};
	if !(isnil "tpwcarexc_4") then {tpw_car_excarray set [count tpw_car_excarray,tpwcarexc_4]};
	if !(isnil "tpwcarexc_5") then {tpw_car_excarray set [count tpw_car_excarray,tpwcarexc_5]};
	if !(isnil "tpwcarexc_6") then {tpw_car_excarray set [count tpw_car_excarray,tpwcarexc_6]};
	if !(isnil "tpwcarexc_7") then {tpw_car_excarray set [count tpw_car_excarray,tpwcarexc_7]};
	if !(isnil "tpwcarexc_8") then {tpw_car_excarray set [count tpw_car_excarray,tpwcarexc_8]};
	if !(isnil "tpwcarexc_9") then {tpw_car_excarray set [count tpw_car_excarray,tpwcarexc_9]};	

		{
		// If player near exclusion object, no roads to spawn on = no cars
		if (_x distance vehicle player < (tpw_car_radius / 2)) exitwith
			{
			tpw_car_roadlist = [];
			tpw_car_farroads = [];
			tpw_car_exclude = true;
			};		
		} foreach tpw_car_excarray;
	};

sleep 3;
    
// MAIN LOOP - ADD AND REMOVE CARS AS NECESSARY, CHECK IF OTHER PLAYERS HAVE DIED (MP)
while {true} do 
	{
	if (tpw_car_active) then
		{
		private ["_cararray","_deadplayer","_grp","_center","_group","_logic","_driver","_near"];
		tpw_car_removearray = [];

		// Debugging	
		if (tpw_car_debug) then {hintsilent format ["Cars: %1",count tpw_car_cararray]};

		// Reduce radius if player near exclusion zone, to remove close cars
		if (tpw_car_exclude) then 
			{
			tpw_car_radius = tpw_car_radius / 4;
			} 
			else
			{
			tpw_car_radius = tpw_car_radius_orig;
			};

		// Add cars
		if (count tpw_car_cararray < tpw_car_num) then
			{
			0 = [] call tpw_car_fnc_nearcar;
			};

			{
			// Beep horn if near others
			_driver = driver _x;
			_near = (position _x) nearEntities [["man"], 10];
			if (count _near > 0 && {alive _driver} && {_driver distance _x < 2} && {damage _x < 0.2}) then
				{
				_center = createCenter sideLogic;
				_group = createGroup _center;
				_logic = _group createUnit ["LOGIC", [0,0,0], [], 0, "NONE"];
				_logic action ["useWeapon",_x,_driver,0];
				deleteCenter _center;
				deleteVehicle _logic;
				deleteGroup _group;
				};
			
			// Remove commandeer menu from damaged cars or those with dead drivers
			if (damage _x > 0.2 || !(alive _driver)) then
				{
				_x removeaction 0;	
				};
				
			// Slow down near player
			if (_x distance player < tpw_car_slowdist) then 
				{
				_x setSpeedMode "LIMITED";
				} else
				{
				_x setSpeedMode "NORMAL";
				};
			//Conditions for removing car
			if (
			_x distance vehicle player > tpw_car_radius || //car out of range
			(speed _x < 1 && (_x getvariable ["tpw_car_lastspeed",500]) < 1) || // car hasn't moved
			(count (_x nearroads 50) == 0) || // car too far from a road 
			(damage _x > 0.2 && damage _x < 1) // car damaged, but not destroyed
			) then
				{
				// If player can't see the car
				if (lineintersects [eyepos player,getposasl _x,player,_x] || terrainintersectasl [eyepos player,getposasl _x]) then
					{
					// Don't remove a close car even if it's supposedly not visible
					if (_x distance vehicle player > tpw_car_mindist) then 
						{
						//  Remove player as owner, remove from player's car array
						_x setvariable ["tpw_car_owner", (_x getvariable "tpw_car_owner") - [player],true];            
						tpw_car_removearray set [count tpw_car_removearray,_x];    
						};		
					};
				};

			// Delete the car, occupants and waypoints if it's not owned by anyone    
			if (count (_x getvariable ["tpw_car_owner",[]]) == 0) then    
				{
				_grp = _x getvariable "tpw_car_occupants";
				[_grp] call tpw_car_fnc_delete;
				deletevehicle _x;
				};
			_x setvariable ["tpw_car_lastspeed",(speed _x)];	
			} foreach tpw_car_cararray;    

		// Update player's car array    
		tpw_car_cararray = tpw_car_cararray - tpw_car_removearray;
		player setvariable ["tpw_cararray",tpw_car_cararray,true];

		// If MP, check if any other players have been killed and disown their cars
		if (isMultiplayer) then 
			{
				{
				if ((isplayer _x) && !(alive _x)) then
					{
					_deadplayer = _x;
					_cararray = _x getvariable ["tpw_cararray"];
						{
						_x setvariable ["tpw_car_owner",(_x getvariable "tpw_car_owner") - [_deadplayer],true];
						} foreach _cararray;
					};
				} foreach allunits;    
			};
		};	
	sleep random 10;    
	};  
