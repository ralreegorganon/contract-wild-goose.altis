/* 
TPW AIR - Spawn ambient flybys of helicopters and aircraft
Author: tpw 
Date: 20130925
Version: 1.15

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works.     

To use: 
1 - Save this script into your mission directory as eg tpw_air.sqf
2 - Call it with 0 = [10,300,2] execvm "tpw_air.sqf"; where 10 = delay until flybys start (s), 300 = maximum time between flybys (sec). 0 = disable, 2 = maximum aircraft at a given time

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS.
*/

if (isDedicated) exitWith {};
if (count _this < 3) exitwith {hint "TPW AIR incorrect/no config, exiting."};
if !(isnil "tpw_air_active") exitwith {hint "TPW AIR already running."};
if (_this select 1 == 0) exitwith {};
WaitUntil {!isNull FindDisplay 46};

// READ IN CONFIGURATION VALUES
tpw_air_delay = _this select 0; // delay until flybys start
tpw_air_time = _this select 1; // maximum time between flybys
tpw_air_max = _this select 2; // maximum number of aircraft at a given time

// VARIABLES
tpw_air_active = true; // Global enable/disabled
tpw_air_version = 1.15; // Version string
tpw_air_count = 0;

tpw_air_helitypes = [
"B_Heli_Light_01_armed_F",
"B_Heli_Attack_01_F",
"I_Heli_Transport_02_F",
"B_Heli_Transport_01_F",
"B_Heli_Transport_01_camo_F",
"B_Heli_Light_01_F"
];

tpw_air_planetypes = [
"I_Plane_Fighter_03_AA_F"
];

// HELI SPAWN
tpw_air_fnc_heli =
	{
	private ["_pos","_px","_py","_pxoffset","_pyoffset","_dir","_dist","_startx","_endx","_starty","_endy","_startpos","_endpos","_heli"];
	_pos = position (_this select 0);
	_px = _pos select 0;
	_py = _pos select 1;
	
	// Offset so that aircraft doesn't necessarily fly straight over the top of whatever called this function
	_pxoffset = random 2000;
	_pyoffset = random 2000;
	
	// Pick a random direction and distance to spawn
	_dir = random 360;
	_dist = 2000 + (random 5000);
	
	// Calculate start and end positions of flyby
	_startx = _px + (_dist * sin _dir) + _pxoffset;
	_endx = _px - (_dist * sin _dir) + _pxoffset;
	_starty = _py + (_dist * cos _dir) + _pyoffset;
	_endy = _py - (_dist * cos _dir) + _pyoffset;
	_startpos = [_startx,_starty,0];
	_endpos = [_endx,_endy,0];
	
	// Pick random heli
	_heli = tpw_air_helitypes select (floor (random (count tpw_air_helitypes)));
	
	// Flyby
	[_startpos,_endpos, 100 + (random 500),"FULL",_heli,CIVILIAN] spawn bis_fnc_ambientflyby;
	tpw_air_count = tpw_air_count + 1;
	};
	
// JET SPAWN	
tpw_air_fnc_plane =
	{
	private ["_pos","_px","_py","_pxoffset","_pyoffset","_dir","_dist","_startx","_endx","_starty","_endy","_startpos","_endpos"];
	_pos = position (_this select 0);
	_px = _pos select 0;
	_py = _pos select 1;
	
	// Offset so that aircraft doesn't necessarily fly straight over the top of whatever called this function
	_pxoffset = random 2000;
	_pyoffset = random 2000;
	
	// Pick a random direction and distance to spawn
	_dir = random 360;
	_dist = 5000 + (random 5000);
	
	// Calculate start and end positions of flyby
	_startx = _px + (_dist * sin _dir) + _pxoffset;
	_endx = _px - (_dist * sin _dir) + _pxoffset;
	_starty = _py + (_dist * cos _dir) + _pyoffset;
	_endy = _py - (_dist * cos _dir) + _pyoffset;
	_startpos = [_startx,_starty,0];
	_endpos = [_endx,_endy,0];
	
	// Pick random plane
	_plane = tpw_air_planetypes select (floor (random (count tpw_air_planetypes)));
	
	// Flyby
	[_startpos,_endpos, 500 + (random 500),"LIMITED",_plane,WEST] spawn bis_fnc_ambientflyby;
	tpw_air_count = tpw_air_count + 1;
	};	
	
// RUN IT
sleep random tpw_air_delay;

[] spawn 
{	
while {true} do 
	{
	_air = (position player) nearEntities [["air"], 1000];
	if (tpw_air_active && count _air < tpw_air_max) then 
		{
		[player] call tpw_air_fnc_heli;
		};
	sleep (tpw_air_time / 2) + random (tpw_air_time / 2);
	};
};	

[] spawn 
{	
while {true} do 
	{
	_air = (position player) nearEntities [["air"], 1000];
	if (tpw_air_active && count _air < tpw_air_max) then 
		{
		[player] call tpw_air_fnc_plane;
		};
	sleep (tpw_air_time / 2) + random (tpw_air_time / 2);
	};
};	