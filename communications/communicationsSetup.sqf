if (!isServer) exitWith {};

_grp = [getmarkerpos "comm_garrison_spawn_1", EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSentry")] call BIS_fnc_spawnGroup;
_leader = leader _grp;
[_leader, 20, true, [100,2], true, true] execVM "garrison_script\Garrison_script.sqf";

// Patrols
_grp = [getmarkerpos "comm_ups_spawn_1", EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSentry")] call BIS_fnc_spawnGroup;
_leader = leader _grp;
[_leader, "comm_ups_patrols_1"] execVM "ups\ups.sqf";

_grp = [getmarkerpos "comm_ups_spawn_2", EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSentry")] call BIS_fnc_spawnGroup;
_leader = leader _grp;
[_leader, "comm_ups_patrols_1"] execVM "ups\ups.sqf";

_grp = [getmarkerpos "comm_ups_spawn_3", EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSentry")] call BIS_fnc_spawnGroup;
_leader = leader _grp;
[_leader, "comm_ups_patrols_1"] execVM "ups\ups.sqf";

_grp = [getmarkerpos "comm_ups_spawn_4", EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized_MTP" >> "OIA_MotInf_Team")] call BIS_fnc_spawnGroup;
_leader = leader _grp;
[_leader, "comm_ups_patrols_2"] execVM "ups\ups.sqf";
