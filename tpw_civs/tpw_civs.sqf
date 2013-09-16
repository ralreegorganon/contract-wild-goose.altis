/* 
AMBIENT CIVILIAN SCRIPT - SP/MP CLIENT COMPATIBLE
Author: tpw 
Date: 20130914
Version: 1.12

    - This script will gradually spawn civilians into habitable houses within a specified radius of the player.
    - Civilian density (how many houses per civilian) can be specified.
    - Civilian density will halve at night.
    - Civilians will then wander from house to house, with a specified number of waypoints
    - If a civilian is killed another will spawn 
    - Civs are removed if more than the specified radius from the player
	- The mission will fail if the number of civilian casualties exceeds player defined threshold

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works.     

To use: 
1 - Save this script into your mission directory as eg tpw_civs.sqf
2 - Call it with 0 = [1,5,150,15,5,4,50,0] execvm "tpw_civs.sqf"; where 1 = start hint, 5 = start delay,150 = radius, 15 = number of waypoints, 10 = how many houses per civilian, 4 = maximum squad inflicted civ casualties, 50 = max total casualties, 0 = what to do if casualty threshold exceeded (0 -nothing, 1 - popup message, 2 - end mission) 

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS
*/


if (isDedicated) exitWith {};
if (count _this < 8) exitwith {hint "TPW CIVS incorrect/no config, exiting."};
if (_this select 4 == 0) exitwith {};
if !(isnil "tpw_civ_active") exitwith {hint "TPW CIVS already running."};
WaitUntil {!isNull FindDisplay 46};



private ["_civlist","_clothes","_sqname","_centrec"];

// READ IN VARIABLES
tpw_civ_hint = _this select 0;
tpw_civ_sleep = _this select 1;
tpw_civ_radius = _this select 2;
tpw_civ_waypoints = _this select 3;
tpw_civ_density = _this select 4;
tpw_civ_maxsquadcas  = _this select 5;
tpw_civ_maxallcas  = _this select 6;
tpw_civ_casdisplay = _this select 7;

// DFAULT VALUES IF MP
if (isMultiplayer) then 
	{
	tpw_civ_hint =0;
	tpw_civ_sleep = 5;
	tpw_civ_radius = 150;
	tpw_civ_waypoints = 15;
	tpw_civ_density =5;
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

tpw_civ_habitable = [ // Habitable houses with white walls, red roofs, intact doors and windows
"Land_i_House_Small_01_V1_F",
"Land_i_House_Small_02_V1_F",
"Land_i_House_Big_02_V1_F",
"Land_i_House_Small_03_V1_F",
"Land_i_House_Big_01_V1_F",
"Land_i_House_Small_01_V2_F"
];


tpw_civ_civarray = []; // array holding spawned civs
tpw_civ_houses = []; // array holding civilian houses near player
tpw_civ_civnum = 0; // number of civs to spawn
tpw_civ_debug = false;
tpw_civ_allcas = 0; // all civ casualities 
tpw_civ_squadcas = 0; // civ casualities caused by squad
tpw_civ_active = true; // global activate/deactivate
tpw_civ_version = 1.12; // Version string


// HINT
if (tpw_civ_hint == 1) then
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
	
sleep tpw_civ_sleep;


// CREATE AI CENTRES SO SPAWNED UNITS KNOW WHO'S AN ENEMY
_centerC = createCenter civilian;

// IF CIV IS SHOT BY PLAYER
tpw_civ_fnc_casualty = 
    {
    private ["_civ","_shooter"];
	_civ = _this select 0;
	_shooter = _this select 1;
	if (_civ getvariable ["tpw_civ_cas",0] == 0) then
		{
		_civ setvariable ["tpw_civ_cas",1];
		tpw_civ_allcas = tpw_civ_allcas + 1;
		if (_shooter in (units (group player))) then 
			{
			tpw_civ_squadcas = tpw_civ_squadcas + 1;
			};
		};
	if (tpw_civ_allcas > tpw_civ_maxallcas || tpw_civ_squadcas > tpw_civ_maxsquadcas) then 
		{
		switch tpw_civ_casdisplay do
			{
			case 1: 
				{
				hint format ["Warning: significant civilian casualties!\n %1 total casualties.\n%2 attributed to your squad.",tpw_civ_allcas,tpw_civ_squadcas];
				};
			case 2:
				{
				["end7",false,2] call BIS_fnc_endMission;
				};
			};	
		};
	};

// WAYPOINTS AT DIFFERENT HOUSES
tpw_civ_fnc_waypoint = 
	{
	private ["_grp","_house","_m","_pos","_wp"];
	//Pick random position within random house
	_grp = _this select 0;
	waituntil
		{
		_house = tpw_civ_houses select (floor (random (count tpw_civ_houses)));
		((leader _grp) distance _house < 150); 
		};
	_wp = getposasl _house;
	_grp addWaypoint [_wp, 0];
	};

// SPAWN CIV INTO EMPTY GROUP
tpw_civ_fnc_civspawn =
	{
	private ["_civ","_spawnpos","_i","_ct","_sqname"];
	// Pick a random house for civ to spawn into
	_spawnpos = getposasl (tpw_civ_houses select (floor (random (count tpw_civ_houses))));
	_civ = _civlist select (floor (random (count _civlist)));

	//Spawn civ into empty group
	_sqname = creategroup civilian;
	_civ createUnit [_spawnpos, _sqname];

	// Random clothes
	removeUniform (leader _sqname);
	(leader _sqname) addUniform (_clothes select  (floor (random (count _clothes))));

	//Mark it as owned by this player
	(leader _sqname) setvariable ["tpw_civ_owner", [player],true];

	//Add killed/hit eventhandlers
	(leader _sqname) addeventhandler ["Hit",{_this call tpw_civ_fnc_casualty}];
	(leader _sqname) addeventhandler ["Killed",{_this call tpw_civ_fnc_casualty}];

	//Add it to the array of civs for this player
	tpw_civ_civarray set [count tpw_civ_civarray,leader _sqname];

	//Speed and behaviour
	_sqname setspeedmode "LIMITED";
	_sqname setBehaviour "SAFE";

	//Assign waypoints
	for "_i" from 1 to tpw_civ_waypoints do
		{
		0 = [_sqname] call tpw_civ_fnc_waypoint; 
		};
	[_sqname, (tpw_civ_waypoints - 1)] setWaypointType "CYCLE";
	};
    
// SEE IF ANY CIVS OWNED BY OTHER PLAYERS ARE WITHIN RANGE, WHICH CAN BE USED INSTEAD OF SPAWNING A NEW CIV
tpw_civ_fnc_nearciv =
	{
	private ["_owner","_shareflag"];
	_shareflag = 0;
	if (isMultiplayer) then         
		{
			{
			// Live units within range
			if (_x distance vehicle player < tpw_civ_radius && alive _x) then 
				{
				_owner = _x getvariable ["tpw_civ_owner",[]];

				//Units with owners, but not this player
				if ((count _owner > 0) && !(player in _owner)) exitwith
					{
					_shareflag = 1;
					_owner set [count _owner,player]; // add player as another owner of this civ
					_x setvariable ["tpw_civ_owner",_owner,true]; // update ownership
					tpw_civ_civarray set [count tpw_civ_civarray,_x]; // add this civ to the array of civs for this player
					};
				};
			} foreach allunits;
		};    

	//Otherwise, spawn a new civ
	if (_shareflag == 0) then 
		{
		[] call tpw_civ_fnc_civspawn;    
		};     
	};
	
// PERIODICALLY UPDATE POOL OF ENTERABLE HOUSES NEAR PLAYER, DETERMINE MAX CIVILIAN NUMBER, DISOWN CIVS FROM DEAD PLAYERS IN MP
0 = [] spawn 
	{
	while {true} do
		{ 
		private ["_civarray","_deadplayer"];
		tpw_civ_houses = nearestObjects [position vehicle player,tpw_civ_habitable,tpw_civ_radius]; 
		tpw_civ_civnum = floor ((count tpw_civ_houses) / tpw_civ_density);

		// Fewer civs at night
		if (daytime < 5 || daytime > 20) then 
			{
			tpw_civ_civnum = floor (tpw_civ_civnum / 2);
			};

		// Check if any players have been killed and disown their civs
		if (isMultiplayer) then 
			{
				{
				if ((isplayer _x) && !(alive _x)) then
					{
					_deadplayer = _x;
					_civarray = _x getvariable ["tpw_civarray"];
						{
						_x setvariable ["tpw_civ_owner",(_x getvariable "tpw_civ_owner") - [_deadplayer],true];
						} foreach _civarray;
					};
				} foreach allunits;    
			};
		sleep 10;
		};
	};

// MAIN LOOP - ADD AND REMOVE CIVS AS NECESSARY
while {true} do 
	{
	if (tpw_civ_active) then
		{
		private ["_group"];
		tpw_civ_removearray = [];

		//Debugging
		if (tpw_civ_debug) then {hintsilent format ["Civs:%1 Houses:%2",count tpw_civ_civarray,count tpw_civ_houses]};

		// Add civs if there are less than the calculated civilian density for the player's current location 
		if ((count tpw_civ_civarray < tpw_civ_civnum) && (count tpw_civ_houses > 0)) then
			{
			[] call tpw_civ_fnc_nearciv;
			};

			{
			// Remove dead civ from players array (but leave body)
			if !(alive _x) then 
				{
				tpw_civ_removearray set [count tpw_civ_removearray,_x];    
				}
				else
				{    
				// Check if civ is out of range and not visible to player. If so, disown it and remove it from players civ array    
				if (_x distance vehicle player > tpw_civ_radius && ((lineintersects [eyepos player,getposasl _x,player,_x]) || (terrainintersectasl [eyepos player,getposasl _x]))) then
					{
					_x setvariable ["tpw_civ_owner", (_x getvariable "tpw_civ_owner") - [player],true];            
					tpw_civ_removearray set [count tpw_civ_removearray,_x];    
					};

				// Delete the live civ and its waypoints if it's not owned by anyone    
				if (count (_x getvariable ["tpw_civ_owner",[]]) == 0) then
					{
					while {(count (waypoints( group _x))) > 0} do
						{
						deleteWaypoint ((waypoints (group _x)) select 0);
						};
					_group = group _x;	
					deletevehicle _x;
					deletegroup _group;
					};    
				};    
			} foreach tpw_civ_civarray;

		//Update player's civ array    
		tpw_civ_civarray = tpw_civ_civarray - tpw_civ_removearray;
		player setvariable ["tpw_civarray",tpw_civ_civarray,true];   
		};
	sleep random 10;    
	};  