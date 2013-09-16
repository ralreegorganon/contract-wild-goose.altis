/* 
TPW AIR - Spawn ambient flybys of helicopters and aircraft
Author: tpw 
Date: 20130914
Version: 1.12

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works.     

To use: 
1 - Save this script into your mission directory as eg tpw_air.sqf
2 - Call it with 0 = [1,10,300] execvm "tpw_air.sqf"; where 1 = startup hint, 10 = delay until flybys start (s), 300 = maximum time between flybys (sec). 0 = disable

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS.
*/

if (isDedicated) exitWith {};
if (count _this < 3) exitwith {hint "TPW AIR incorrect/no config, exiting."};
if !(isnil "tpw_air_active") exitwith {hint "TPW AIR already running."};
if (_this select 2 == 0) exitwith {};
WaitUntil {!isNull FindDisplay 46};

// READ IN CONFIGURATION VALUES
tpw_air_hint = _this select 0; // start hint
tpw_air_delay = _this select 1; // delay until flybys start
tpw_air_time = _this select 2; // maximum time between flybys
tpw_air_active = true; // Global enable/disabled
tpw_air_version = 1.12; // Version string

// VARIABLES
tpw_helitypes = [
"B_Heli_Light_01_armed_F",
"B_Heli_Attack_01_F",
"I_Heli_Transport_02_F",
"B_Heli_Transport_01_F",
"B_Heli_Transport_01_camo_F",
"B_Heli_Light_01_F"
];

// HINT
if (tpw_air_hint == 1) then
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

// HELI SPAWN
tpw_air_fnc_heli =
	{
	private ["_pos","_x","_y","_xoffset","_yoffset","_dir","_dist","_startx","_endx","_starty","_endy","_startpos","_endpos","_heli"];
	_pos = position (_this select 0);
	_x = _pos select 0;
	_y = _pos select 1;
	
	// Offset so that aircraft doesn't necessarily fly straight over the top of whatever called this function
	_xoffset = random 2000;
	_yoffset = random 2000;
	
	// Pick a random direction and distance to spawn
	_dir = random 360;
	_dist = 2000 + (random 5000);
	
	// Calculate start and end positions of flyby
	_startx = _x + (_dist * sin _dir) + _xoffset;
	_endx = _x - (_dist * sin _dir) + _xoffset;
	_starty = _y + (_dist * cos _dir) + _yoffset;
	_endy = _y - (_dist * cos _dir) + _yoffset;
	_startpos = [_startx,_starty,0];
	_endpos = [_endx,_endy,0];
	
	// Pick random heli
	_heli = tpw_helitypes select (floor (random (count tpw_helitypes)));
	
	// Flyby
	[_startpos,_endpos, 100 + (random 500),"FULL",_heli,CIVILIAN] spawn bis_fnc_ambientflyby;
	};
	
// JET SPAWN	
tpw_air_fnc_jet =
	{
	private ["_pos","_x","_y","_xoffset","_yoffset","_dir","_dist","_startx","_endx","_starty","_endy","_startpos","_endpos"];
	_pos = position (_this select 0);
	_x = _pos select 0;
	_y = _pos select 1;
	
	// Offset so that aircraft doesn't necessarily fly straight over the top of whatever called this function
	_xoffset = random 2000;
	_yoffset = random 2000;
	
	// Pick a random direction and distance to spawn
	_dir = random 360;
	_dist = 5000 + (random 5000);
	
	// Calculate start and end positions of flyby
	_startx = _x + (_dist * sin _dir) + _xoffset;
	_endx = _x - (_dist * sin _dir) + _xoffset;
	_starty = _y + (_dist * cos _dir) + _yoffset;
	_endy = _y - (_dist * cos _dir) + _yoffset;
	_startpos = [_startx,_starty,0];
	_endpos = [_endx,_endy,0];
	
	// Flyby
	[_startpos,_endpos, 500 + (random 500),"LIMITED","I_Plane_Fighter_03_AA_F",WEST] spawn bis_fnc_ambientflyby;
	};	
	
// RUN IT
sleep random tpw_air_time;
[] spawn 
{	
while {true} do 
	{
	if (tpw_air_active) then 
		{
		[player] call tpw_air_fnc_heli;
		};
	sleep random tpw_air_time;
	};
};	

[] spawn 
{	
while {true} do 
	{
	if (tpw_air_active) then 
		{
		[player] call tpw_air_fnc_jet;
		};
	sleep random tpw_air_time;
	};
};	