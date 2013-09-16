if (!isServer) exitWith {};

// Road block 1
_grp = [getmarkerpos "extract_ups_spawn_1", resistance, (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfSentry")] call BIS_fnc_spawnGroup;
_leader = leader _grp;
[_leader, "extract_ups_patrols_1"] execVM "ups\ups.sqf";

// Road block 2
_grp = [getmarkerpos "extract_ups_spawn_2", resistance, (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfSquad")] call BIS_fnc_spawnGroup;
_leader = leader _grp;
[_leader, "extract_ups_patrols_2"] execVM "ups\ups.sqf";

// Road block 3
_grp = [getmarkerpos "extract_ups_spawn_3", resistance, (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfSquad")] call BIS_fnc_spawnGroup;
_leader = leader _grp;
[_leader, "extract_ups_patrols_3"] execVM "ups\ups.sqf";

// City
_grp = [getmarkerpos "extract_ups_spawn_4", resistance, (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfSquad")] call BIS_fnc_spawnGroup;
_leader = leader _grp;
[_leader, "extract_ups_patrols_4"] execVM "ups\ups.sqf";

_grp = [getmarkerpos "extract_ups_spawn_5", resistance, (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfSquad")] call BIS_fnc_spawnGroup;
_leader = leader _grp;
[_leader, "extract_ups_patrols_4"] execVM "ups\ups.sqf";

_grp = [getmarkerpos "extract_ups_spawn_6", resistance, (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Motorized" >> "HAF_MotInf_Team")] call BIS_fnc_spawnGroup;
_leader = leader _grp;
[_leader, "extract_ups_patrols_4"] execVM "ups\ups.sqf";

_grp = [getmarkerpos "extract_ups_spawn_7", resistance, (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfSquad")] call BIS_fnc_spawnGroup;
_leader = leader _grp;
[_leader, "extract_ups_patrols_4"] execVM "ups\ups.sqf";

_grp = [getmarkerpos "extract_ups_spawn_8", resistance, (configfile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Motorized" >> "HAF_MotInf_Team")] call BIS_fnc_spawnGroup;
_leader = leader _grp;
[_leader, "extract_ups_patrols_4"] execVM "ups\ups.sqf";	