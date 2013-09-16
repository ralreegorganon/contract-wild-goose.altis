/* 
AMBIENT CIVILIAN BOAT SCRIPT - SP/MP CLIENT COMPATIBLE
Author: tpw 
Date: 20130914
Version: 1.12

	- This script will gradually spawn civilian boats, up to a maximum specified, onto the ocean within a specified radius of the player.
	- Boats will then move around, with a specified number of waypoints.
	- If a civilian driver is killed or boat damaged another will spawn.
	- Boats are removed if more than the specified radius from the player.

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works.     

To use: 
1 - Save this script into your mission directory as eg tpw_boats.sqf
2 - Call it with 0 = [1,5,1000,15,2] execvm "tpw_boats.sqf"; where 1= start hint, 5 = start delay, 1000 = radius, 15 = number of waypoints, 2 = max boats

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS
*/

if (isDedicated) exitWith {};
if (count _this < 5) exitwith {hint "TPW CARS incorrect/no config, exiting."};
if (_this select 4 == 0) exitwith {};
if !(isnil "tpw_boat_active") exitwith {hint "TPW BOATS already running."};
WaitUntil {!isNull FindDisplay 46};

// READ IN VARIABLES
tpw_boat_hint = _this select 0;
tpw_boat_sleep = _this select 1;
tpw_boat_radius = _this select 2;
tpw_boat_waypoints = _this select 3;
tpw_boat_num = _this select 4;

// DEFAULT VALUES IF MP
if (isMultiplayer) then 
	{
	tpw_boat_hint =0;
	tpw_boat_sleep = 5;
	tpw_boat_radius = 1000;
	tpw_boat_waypoints = 15;
	tpw_boat_num =2;
	};

tpw_boat_version = 1.12; // Version string
tpw_boat_active = true; // Global enable/disable
tpw_boat_debug = false; // Debugging
tpw_boat_boatarray = []; // Player's array of boats
tpw_boat_mindist = 200; // Don't remove boats closer than this
tpw_boat_slowdist = 100; // Boats slow down when this close 
tpw_boat_spawnradius = tpw_boat_radius / 2; // Boats will spwn this far from player


_boatlist = [
"C_Boat_Civil_01_F",
"C_Boat_Civil_01_police_F",
"C_Boat_Civil_01_rescue_F",
"C_rubberboat"];

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
"U_C_WorkerCoveralls",
"U_IG_Guerilla1_1",
"U_IG_Guerilla2_2",
"U_IG_Guerilla2_3",
"U_IG_Guerilla3_1",
"U_IG_Guerilla3_2",
"U_NikosBody",
"U_Rangemaster"];

// HINT
if (tpw_boat_hint == 1) then
	{
	0 = [] spawn 
		{
		private ["_hint","_hintsleep"];
		_hintsleep = 0;
		_hint = "<t color='#cc9900'>TPW mods active:</t> ";
		if !(isnil "tpw_air_version") then {_hintsleep = _hintsleep + 1;_hint = format ["%1<br/>AIR %2",_hint,tpw_air_version]};		
		if !(isnil "tpw_animal_version") then {_hintsleep = _hintsleep + 1;_hint = format ["%1<br/>ANIMALS %2",_hint,tpw_animal_version]};
		if !(isnil "tpw_bleedout_version") then {_hintsleep = _hintsleep + 1;_hint = format ["%1<br/>BLEEDOUT %2",_hint,tpw_bleedout_version]};
		if !(isnil "tpw_boat_version") then {_hintsleep = _hintsleep + 1;_hint = format ["%1<br/>BOATS %2",_hint,tpw_boat_version]};
		if !(isnil "tpw_car_version") then {_hintsleep = _hintsleep + 1;_hint = format ["%1<br/>CARS %2",_hint,tpw_car_version]};
		if !(isnil "tpw_civ_version") then {_hintsleep = _hintsleep + 1;_hint = format ["%1<br/>CIVS %2",_hint,tpw_civ_version]};
		if !(isnil "tpw_ebs_version") then {_hintsleep = _hintsleep + 1;_hint = format ["%1<br/>EBS %2",_hint,tpw_ebs_version]};
		if !(isnil "tpw_fall_version") then {_hintsleep = _hintsleep + 1;_hint = format ["%1<br/>FALL %2",_hint,tpw_fall_version]};
		if !(isnil "tpw_fog_version") then {_hintsleep = _hintsleep + 1;_hint = format ["%1<br/>FOG %2",_hint,tpw_fog_version]};
		if !(isnil "tpw_houselights_version") then {_hintsleep = _hintsleep + 1;_hint = format ["%1<br/>HOUSELIGHTS %2",_hint,tpw_houselights_version]};
		if !(isnil "tpwlos_version") then {_hint = format ["%1<br/>LOS %2",_hint,tpwlos_version]};
		sleep 10;
		hintsilent parsetext format ["<t size = '0.9'> %1</t>",_hint];
		sleep _hintsleep;
		hintsilent "";
		};	
	};

// CREATE AI CENTRE
_centerC = createCenter civilian;

//FIND WATER NEAR PLAYER
tpw_boat_fnc_findwater = 
	{
	private ["_pos","_posx","_posy","_dir"];
	_pos = position player;
	_dir = random 360;;
	for "_i" from 1 to 10 do
		{
		_posx = (_pos select 0) + (tpw_boat_spawnradius * sin _dir);
		_posy = (_pos select 1) +  (tpw_boat_spawnradius * cos _dir);
		tpw_boat_waterpos = [_posx,_posy,0]; 
		if (surfaceIsWater tpw_boat_waterpos) exitwith {[] call tpw_boat_fnc_spawnboat};
		_dir = _dir + 30; 
		if (_dir > 360) then 
			{
			_dir = _dir - 360
			};
		};
	};
	
// SPAWN BOAT/DRIVER IN THE WATER
tpw_boat_fnc_spawnboat =
	{
	private ["_boat","_spawnboat"];
	
	//Random boat
	_sqname = creategroup civilian;
	_boat = _boatlist select (floor (random (count _boatlist)));
	_spawnboat = _boat createVehicle tpw_boat_waterpos;
	
	// Random civ
	_civ = _civlist select (floor (random (count _civlist)));
	_civ createunit [tpw_boat_waterpos,_sqname,"this moveindriver _spawnboat;this setbehaviour 'CARELESS'"]; 
	
	// Random clothes
	removeUniform (leader _sqname);
	(leader _sqname) addUniform (_clothes select  (floor (random (count _clothes)))); 
	
	//Add killed/hit eventhandlers to driver
	(leader _sqname) addeventhandler ["Hit",{_this call tpw_civ_fnc_casualty}];
	(leader _sqname) addeventhandler ["Killed",{_this call tpw_civ_fnc_casualty}];
	
	// Assign waypoints
	[_sqname] call tpw_boat_fnc_waypoints;
	
	//Mark it as owned by this player
	_spawnboat setvariable ["tpw_boat_owner",[player],true];

	//Mark boat's driver
	_spawnboat setvariable ["tpw_boat_driver",(leader _sqname),true];
	
	// Add it to player's boat array
	tpw_boat_boatarray set [count tpw_boat_boatarray,_spawnboat];
	};	
	
// SEE IF ANY BOATS OWNED BY OTHER PLAYERS ARE WITHIN RANGE, USE THESE INSTEAD OF SPAWNING A NEW BOAT (MP)
tpw_boat_fnc_nearboat =
	{
	private ["_owner","_nearboats","_shareflag"];
	_spawnflag = 1;
	if (isMultiplayer) then 
		{
		// Array of near boats
		_nearboats = (position player) nearEntities [["Ship"], tpw_boat_radius];

			// Live boats within range
			{    
			if (_x distance vehicle player < tpw_boat_radius && alive _x) then   
				{
				_owner = _x getvariable ["tpw_boat_owner",[]];

				//Units with owners, but not this player
				if ((count _owner > 0) && !(player in _owner)) exitwith
					{
					_spawnflag = 0;
					_owner set [count _owner,player]; // add player as another owner of this car
					_x setvariable ["tpw_boat_owner",_owner,true]; // update ownership
					tpw_boat_boatarray set [count tpw_boat_boatarray,_x]; // add this boat to the array of boats for this player
					};
				} 
			} foreach _nearboats;   
		};
	//Otherwise, spawn a new boat
	if (_spawnflag == 1) then 
		{
		[] call tpw_boat_fnc_findwater;    
		};
	};  	

// WATER WAYPOINTS
tpw_boat_fnc_waypoints =
	{
	private ["_grp","_posx","_posy","_wp"];
	_grp = _this select 0;
	_grp addWaypoint [tpw_boat_waterpos, 50];
	
	for "_i" from 1 to tpw_boat_waypoints do
		{
		waituntil 
			{
			_dir = random 360;
			_dist = 100 + (random tpw_boat_radius);
			_posx = (tpw_boat_waterpos select 0) + (_dist * sin _dir);
			_posy = (tpw_boat_waterpos select 1) + (_dist * cos _dir);
			_wp = [_posx,_posy,0]; 
			(surfaceIsWater _wp);
			};
		_grp addWaypoint [_wp, 50];
		};
	[_grp, (tpw_boat_waypoints - 1)] setWaypointType "CYCLE";
	};
	
//[] call tpw_boat_fnc_nearboat;	



// MAIN LOOP - ADD AND REMOVE BOATS AS NECESSARY, CHECK IF OTHER PLAYERS HAVE DIED (MP)
while {true} do 
	{
	if (tpw_boat_active) then
		{
		private ["_driver","_boatarray","_deadplayer","_group"];
		tpw_boat_removearray = [];

		// Debugging	
		if (tpw_boat_debug) then {hintsilent format ["boats: %1",count tpw_boat_boatarray]};

		// Add boats
		if (count tpw_boat_boatarray < tpw_boat_num) then
			{
			0 = [] call tpw_boat_fnc_nearboat;
			};

			{
			// Slow down near player
			if (_x distance player < tpw_boat_slowdist) then 
				{
				_x setSpeedMode "LIMITED";
				} else
				{
				_x setSpeedMode "NORMAL";
				};
			//Conditions for removing boat
			if (
			_x distance vehicle player > tpw_boat_radius || //boat out of range
			(speed _x < 1 && (_x getvariable ["tpw_boat_lastspeed",500]) < 1) || // boat hasn't moved
			(damage _x > 0.2 && damage _x < 1) // boat damaged, but not destroyed
			) then
				{
				// If player can't see the boat
				if (lineintersects [eyepos player,getposasl _x,player,_x] || terrainintersectasl [eyepos player,getposasl _x]) then
					{
					// Don't remove a close boat even if it's supposedly not visible
					if (_x distance vehicle player > tpw_boat_mindist) then 
						{
						//  Remove player as owner, remove from player's boat array
						_x setvariable ["tpw_boat_owner", (_x getvariable "tpw_boat_owner") - [player],true];            
						tpw_boat_removearray set [count tpw_boat_removearray,_x];    
						};		
					};
				};

			// Delete the boat, driver and waypoints if it's not owned by anyone    
			if (count (_x getvariable ["tpw_boat_owner",[]]) == 0) then    
				{
				_driver = _x getvariable "tpw_boat_driver";
				while {(count (waypoints( group _driver))) > 0} do
					{
					deleteWaypoint ((waypoints (group _driver)) select 0);
					};
				_group = (group _driver);
				moveout _driver; 
				deletevehicle _driver;
				deletevehicle _x;
				deletegroup _group;
				};
			_x setvariable ["tpw_boat_lastspeed",(speed _x)];	
			} foreach tpw_boat_boatarray;    

		// Update player's boat array    
		tpw_boat_boatarray = tpw_boat_boatarray - tpw_boat_removearray;
		player setvariable ["tpw_boatarray",tpw_boat_boatarray,true];

		// If MP, check if any other players have been killed and disown their boats
		if (isMultiplayer) then 
			{
				{
				if ((isplayer _x) && !(alive _x)) then
					{
					_deadplayer = _x;
					_boatarray = _x getvariable ["tpw_boatarray"];
						{
						_x setvariable ["tpw_boat_owner",(_x getvariable "tpw_boat_owner") - [_deadplayer],true];
						} foreach _boatarray;
					};
				} foreach allunits;    
			};
		};	
	sleep random 10;    
	};  
	
