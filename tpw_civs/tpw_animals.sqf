/* 
TPW ANIMALS - Spawn ambient animals around player. SP and MP client
Author: tpw 
Date: 20130930
Version: 1.18

	- This script will gradually spawn animals, up to a maximum specified, within a specified radius of the player.
	- Animals will not spawn too near the player, into water, onto roads or too near buildings.
	- Animals will exhibit their default behaviours (moving, eating etc).
	- Animals will be removed if beyond a specified distance from the player.
	- If an animal is killed another will spawn.
	- Animals will not be spawned if player is in proximity to an exclusion object (up to 10 objects may be specified).
	- New animals will not be spawned if existing animals spawned by another playe are near the player - MP.  

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works.     

To use: 
1 - Save this script into your mission directory as eg tpw_animals.sqf
2 - Call it with 0 = [10,15,200,75,60] execvm "tpw_animals.sqf"; where 10 = start delay, 15 = maximum animals near player, 200 = animals will be removed beyond this distance (m), 75 = minimum distance from player to spawn an animal (m), 60 = maximum time between dog/cat noises (sec)

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS.
*/

if (isDedicated) exitWith {};
if (count _this < 5) exitwith {hint "TPW ANIMALS incorrect/no config, exiting."};
if !(isnil "tpw_animal_active") exitwith {hint "TPW ANIMALS already running."};
if (_this select 1 == 0) exitwith {};
WaitUntil {!isNull FindDisplay 46};

// READ IN CONFIGURATION VALUES
tpw_animal_sleep = _this select 0; // delay until animals start spawning
tpw_animal_max = _this select 1; // maximum animals near player
tpw_animal_maxradius = _this select 2; // distance beyond which animals will be removed
tpw_animal_minradius = _this select 3; // minimum distance from player to spawn animals
tpw_animal_noisetime = _this select 4; // maximum time in between animal noises

// DEFAULT VALUES FOR MP
if (isMultiplayer) then 
	{
	tpw_animal_sleep = 10; 
	tpw_animal_max =15; 
	tpw_animal_maxradius = 200;
	tpw_animal_minradius = 75;
	};

// VARIABLES
tpw_animal_debug = false; // debugging
tpw_animal_array = []; // array of animals near player
tpw_animal_exclude = false; // player near exlusion object
tpw_animal_active = true; // global activate/deactivate
tpw_animal_version = 1.18; // Version string

tpw_animals = // array of animals and their min / max flock sizes
[["Hen_random_F",2,4], // chicken
["Hen_random_F",2,4],
["Sheep_random_F",3,6], // sheep
["Sheep_random_F",3,6],
["Goat_random_F",3,6], // goat
["Goat_random_F",3,6],
["Alsatian_random_F",1,1], // alsation
["Fin_random_F",1,1]]; // mutt

tpw_animals_habitable = [ // Habitable houses with white walls, red roofs, intact doors and windows
"Land_i_House_Small_01_V1_F",
"Land_i_House_Small_01_V2_F",
"Land_i_House_Small_01_V3_F",
"Land_i_House_Small_02_V1_F",
"Land_i_House_Small_02_V2_F",
"Land_i_House_Small_02_V3_F",
"Land_i_House_Small_03_V1_F",
"Land_i_House_Big_01_V1_F",
"Land_i_House_Big_01_V2_F",
"Land_i_House_Big_01_V3_F",
"Land_i_House_Big_02_V1_F",
"Land_i_House_Big_02_V2_F",
"Land_i_House_Big_02_V3_F"
];

// DELAY
sleep tpw_animal_sleep;

// CONDITIONS FOR SPAWNING A NEW ANIMAL
tpw_animal_fnc_nearanimal =
	{
	private ["_owner","_spawnflag","_deadplayer","_animalarray"];
	
	_spawnflag = true; // only spawn animal if this is true

	// Check if any players have been killed and disown their animals - MP
	if (isMultiplayer) then 
		{
			{
			if ((isplayer _x) && !(alive _x)) then
				{
				_deadplayer = _x;
				_animalarray = _x getvariable ["tpw_animalarray"];
					{
					_x setvariable ["tpw_animal_owner",(_x getvariable "tpw_animal_owner") - [_deadplayer],true];
					} foreach _animalarray;
				};
			} foreach allunits;    

		// Any nearby animals owned by other players - MP
		_nearanimals = (position player) nearentities [["Fowl_Base_F", "Dog_Base_F", "Goat_Base_F", "Sheep_Random_F"],tpw_animal_maxradius]; 
			{
			_owner = _x getvariable ["tpw_animal_owner",[]];
	
			//Animals with owners who are not this player
			if ((count _owner > 0) && !(player in _owner)) exitwith
				{
				_spawnflag = false;
				_owner set [count _owner,player]; // add player as another owner of this animal
				_x setvariable ["tpw_animal_owner",_owner,true]; // update ownership
				tpw_animal_array set [count tpw_animal_array,_x]; // add this animal to the array of animals for this player
				};
			} foreach _nearanimals;
		};  
		
	// Refresh array of exclusion objects
	tpw_animal_excarray = [];
	tpw_animal_exclude = false;	
	if !(isnil "tpwanimexc") then {tpw_animal_excarray set [count tpw_animal_excarray,tpwanimexc]};
	if !(isnil "tpwanimexc_1") then {tpw_animal_excarray set [count tpw_animal_excarray,tpwanimexc_1]};	
	if !(isnil "tpwanimexc_2") then {tpw_animal_excarray set [count tpw_animal_excarray,tpwanimexc_2]};
	if !(isnil "tpwanimexc_3") then {tpw_animal_excarray set [count tpw_animal_excarray,tpwanimexc_3]};
	if !(isnil "tpwanimexc_4") then {tpw_animal_excarray set [count tpw_animal_excarray,tpwanimexc_4]};
	if !(isnil "tpwanimexc_5") then {tpw_animal_excarray set [count tpw_animal_excarray,tpwanimexc_5]};
	if !(isnil "tpwanimexc_6") then {tpw_animal_excarray set [count tpw_animal_excarray,tpwanimexc_6]};
	if !(isnil "tpwanimexc_7") then {tpw_animal_excarray set [count tpw_animal_excarray,tpwanimexc_7]};
	if !(isnil "tpwanimexc_8") then {tpw_animal_excarray set [count tpw_animal_excarray,tpwanimexc_8]};
	if !(isnil "tpwanimexc_9") then {tpw_animal_excarray set [count tpw_animal_excarray,tpwanimexc_9]};	
	
	// If player near exclusion object then spawn no animals
		{
		
		if (_x distance vehicle player < tpw_animal_maxradius) exitwith
			{
			_spawnflag = false;
			tpw_animal_exclude = true;	
			};		
		} foreach tpw_animal_excarray;	
    
	// Otherwise, spawn a new animal
	if (_spawnflag) then 
		{
		[] spawn tpw_animal_fnc_spawn;    
		};     
	};

// SPAWN ANIMALS INTO APPROPRIATE SPOTS
tpw_animal_fnc_spawn =
	{
	private ["_group","_pos","_dir","_posx","_posy","_randpos","_type","_animal","_water","_roads","_land","_typearray","_type","_flock","_minflock","_maxflock","_diff"];
	
	// Loop until spawn position is not water, house or road
	_pos = getposasl player; 
	_ct = 0;
	waituntil 
		{
		sleep 0.2;
		_dir = random 360;
		_posx = (_pos select 0) + ((tpw_animal_minradius + (random tpw_animal_minradius)) * sin _dir);
		_posy = (_pos select 1) + ((tpw_animal_minradius + (random tpw_animal_minradius)) * cos _dir);
		_randpos = [_posx,_posy,0]; 
		_water = surfaceIsWater _randpos;
		_roads = _randpos nearRoads 15;
		_land = nearestObjects [_randpos, ["land"],5];
		(!(_water) && (count _roads == 0) && (count _land == 0));
		
		};
	_typearray = tpw_animals select (floor (random (count tpw_animals))); // select animal/flocksize
	_type = _typearray select 0; // type of animal
	_minflock = _typearray select 1; // minimum flock size
	_maxflock = _typearray select 2; // maximum flock size
	_diff = round (random (_maxflock - _minflock)); // how many animals more than minimum flock size
	_flock = _minflock + _diff; // flock size
	
	// Spawn flock
	for "_i" from 1 to _flock do 
		{
		sleep random 3;
		_animal = createAgent [_type,_randpos, [], 0, "NONE"];
		_animal setdir random 360;
		_animal setvariable ["tpw_animal_owner",[player],true]; // mark it as owned by this player
		tpw_animal_array set [count tpw_animal_array,_animal]; // add to player's animal array
		player setvariable ["tpw_animalarray",tpw_animal_array,true]; // broadcast it
		};
	};

//DISPERSE	
tpw_animal_disperse = 
	{
	private ["_obj","_animal","_adir","_pdir","_dir","_pos","_posx","_posy"];
	_obj = _this select 0;
	_animal = _this select 1;
	
	if (_animal getvariable ["tpw_animal_disperse",0] == 0) then	
		{
		sleep random 2;
		_animal setvariable	["tpw_animal_disperse",1];
		_adir = [_obj,_animal] call bis_fnc_dirto;
		_pdir = direction _obj;
		_dir = 0;
		if (_adir < _pdir) then
			{
			_dir = _pdir - 45 - random 20;
			}
		else
			{
			_dir = _pdir + 45 + random 20;
			};
		_animal setdir _dir;	
		for "_i" from 1 to (50 + random 100) do
			{
			_pos = position _animal;
			_posx = (_pos select 0) + (0.05 * sin _dir);
			_posy = (_pos select 1) +  (0.05 * cos _dir);
			_animal setposatl [_posx,_posy,0];
			sleep random 0.1;
			};
		_animal setvariable	["tpw_animal_disperse",0];	
		};	
	};	
	
// BARKING DOGS	
tpw_animal_fnc_dogbark =
	{
	private ["_ball","_pos","_dist","_posx","_posy","_barkpos","_bark","_nearhouses","_vol"];		
	
	//Invisible object to attach bark to 
	_ball = "sign_sphere10cm_F" createvehicle [0,0,0];
	_ball setObjectTexture [0,"#(argb,8,8,3)color(0.0,0.0,0.0,0.0,ca)"];	
	while {true} do
		{
		if (player == vehicle player && !(tpw_animal_exclude)) then
			{
			// random position around player
			_pos = getposasl player;
			_dir = random 360;
			_dist = 10 + (random 10);
			_posx = (_pos select 0) + (_dist * sin _dir);
			_posy = (_pos select 1) +  (_dist * cos _dir);
			_barkpos = [_posx,_posy,0]; 
			_ball setposatl _barkpos;
			
			// reduce bark volume away from habitatiom
			_nearhouses = nearestObjects [getPosATL (vehicle player),tpw_animals_habitable,100];
			if (count _nearhouses == 0) then 
				{
				_vol = 0.25
				}
			else
				{
				_vol = 1;
				};
			
			// play bark
			_bark = format ["TPW_SOUNDS\sounds\dog%1.ogg",floor (random 21)];
			playsound3d [_bark,_ball,false,getposasl _ball,_vol,1,50];
			};
		sleep random tpw_animal_noisetime ;
		};
	};	
	
// YOWLING CATS AT NIGHT 	
tpw_animal_fnc_catmeow =
	{
	private ["_nearhouses","_ball","_pos","_dist","_posx","_posy","_meowpos","_meow"];		
	//Invisible object to attach meow to 
	_ball = "sign_sphere10cm_F" createvehicle [0,0,0];
	_ball setObjectTexture [0,"#(argb,8,8,3)color(0.0,0.0,0.0,0.0,ca)"];	
	while {true} do
		{
		_nearhouses = nearestObjects [getPosATL (vehicle player),tpw_animals_habitable,100]; // only have cat noises if near houses	
		if (count _nearhouses > 0 && {(daytime < 5 || daytime > 20)} && {player == vehicle player} && {!(tpw_animal_exclude)}) then
			{
			// random position around player
			_pos = getposasl player;
			_dir = random 360;
			_dist = 15 + (random 10);
			_posx = (_pos select 0) + (_dist * sin _dir);
			_posy = (_pos select 1) +  (_dist * cos _dir);
			_meowpos = [_posx,_posy,0]; 
			_ball setposatl _meowpos;
			
			// play meow
			_meow = format ["TPW_SOUNDS\sounds\cat%1.ogg",floor (random 6)];
			playsound3d [_meow,_ball,false,getposasl _ball,1,0.5 + (random 0.6),50];
			};
		sleep random tpw_animal_noisetime ;
		};
	};	

// BLEATING GOATS 	
tpw_animal_fnc_goatbleat =
	{
	private ["_bleatpos","_bleat","_neargoats","_goat"];		
	while {true} do
		{
		_neargoats = (position player) nearEntities ["goat_base_f", 50];
		if (count _neargoats > 0 && {(daytime < 5 || daytime < 20)} && {player == vehicle player} && {!(tpw_animal_exclude)}) then
			{
			// Random goat
			_goat = _neargoats select (floor (random (count _neargoats)));
			_bleatpos = getposasl _goat; 
			
			// Play bleat
			_bleat = format ["TPW_SOUNDS\sounds\goat%1.ogg",floor (random 6)];
			playsound3d [_bleat,_goat,false,getposasl _goat,2,0.9 + (random 0.2),100];
			};
		sleep random 10;
		};
	};		
	

// MAIN LOOP
tpw_animal_fnc_mainloop = 
	{
	while {true} do
		{
		if (tpw_animal_active) then
			{
			private ["_deleteradius"];

			if (tpw_animal_debug) then
				{
				hintsilent format ["Animals: %1",count tpw_animal_array];
				};
		
			// Shrink deletion radius if near an exclusion zone, to get rid of animals quicker
			if (tpw_animal_exclude) then
				{
				_deleteradius = tpw_animal_minradius;
				} else
				{
				_deleteradius = tpw_animal_maxradius;
				};		
		
			// Spawn animals if there are less than the specified maximum
			if (count tpw_animal_array < tpw_animal_max) then
				{
				[] call tpw_animal_fnc_nearanimal;
				};

			// Remove ownership of distant or dead animals
			tpw_animal_removearray = []; // array of animals to remove
				{
				if (_x distance player > _deleteradius || !(alive _x)) then 
					{
					_x setvariable ["tpw_animal_owner",(_x getvariable "tpw_animal_owner") - [player],true];
					tpw_animal_removearray set [count tpw_animal_removearray,_x];
					};
				
				// Delete live animals with no owners
				if ((count (_x getvariable ["tpw_animal_owner",[]]) == 0) && (alive _x))then	
					{
					deletevehicle _x;
					};
					
				// Animals move away from vehicles
				_near = (position _x) nearEntities [["LandVehicle"], 20];
				if (count _near > 0) then
					{
					[(_near select 0),_x] spawn tpw_animal_disperse;
					};
					
				} foreach tpw_animal_array; 

			// Update player's animal array	
			tpw_animal_array = tpw_animal_array - tpw_animal_removearray;
			player setvariable ["tpw_animalarray",tpw_animal_array,true];
			};	
		sleep random 10;
		};
	};	

// RUN IT
[] spawn tpw_animal_fnc_goatbleat;
[] spawn tpw_animal_fnc_dogbark;
[] spawn tpw_animal_fnc_catmeow;
[] spawn tpw_animal_fnc_mainloop;
 