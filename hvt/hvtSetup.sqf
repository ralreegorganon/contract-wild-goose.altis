if (isServer) 
{
	createCenter civilian;
	_group = createGroup Civilian;
	_building = ((getMarkerPos "hvt_loc_1") nearestObject "Land_i_Barracks_V2_F");
	_initialPos = (_building buildingPos round(random 49));
	hvt = _group createUnit ["C_Nikos", _initialPos, [], 0, "NONE"];
	hvt setBehaviour "CARELESS";
	hvt disableAI "FSM"; 
	hvt allowDamage false;
	[hvt, _building] execVM "hvt\hvtPatrolBuilding.sqf";

	// Building garrison
	_grp = [getmarkerpos "hvt_garrison_spawn_1", EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad")] call BIS_fnc_spawnGroup;
	_leader = leader _grp;
	[_leader, 50, true, [60,4], true, true] execVM "garrison_script\Garrison_script.sqf";

	sleep 5;

	GarrisonGroup2 = [getmarkerpos "hvt_garrison_spawn_2", EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad")] call BIS_fnc_spawnGroup;
	_leader = leader GarrisonGroup2;
	[_leader, 50, false, [60,4], true, true] execVM "garrison_script\Garrison_script.sqf";

	sleep 5;

	GarrisonGroup3 = [getmarkerpos "hvt_garrison_spawn_3", EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad")] call BIS_fnc_spawnGroup;
	_leader = leader GarrisonGroup3;
	[_leader, 50, false, [60,4], true, true] execVM "garrison_script\Garrison_script.sqf";

	// Patrols
	_grp = [getmarkerpos "hvt_ups_spawn_1", EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSentry")] call BIS_fnc_spawnGroup;
	_leader = leader _grp;
	[_leader, "hvt_ups_patrols_1"] execVM "ups\ups.sqf";

	_grp = [getmarkerpos "hvt_ups_spawn_2", EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSentry")] call BIS_fnc_spawnGroup;
	_leader = leader _grp;
	[_leader, "hvt_ups_patrols_1"] execVM "ups\ups.sqf";

	_grp = [getmarkerpos "hvt_ups_spawn_3", EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSentry")] call BIS_fnc_spawnGroup;
	_leader = leader _grp;
	[_leader, "hvt_ups_patrols_1"] execVM "ups\ups.sqf";

	_grp = [getmarkerpos "hvt_ups_spawn_4", EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSentry")] call BIS_fnc_spawnGroup;
	_leader = leader _grp;
	[_leader, "hvt_ups_patrols_1"] execVM "ups\ups.sqf";
}

waitUntil { !isNil("hvt") }
hvt addAction ["Capture","hvt\hvtCapture.sqf", hvt]; 