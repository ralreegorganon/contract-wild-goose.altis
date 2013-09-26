["taskDestroyCommunicationsTower", "succeeded"] call FHQ_TT_setTaskState;

if (!isServer) exitWith {};

{deleteVehicle _x} forEach units GarrisonGroup2;
deleteGroup GarrisonGroup2;
{deleteVehicle _x} forEach units GarrisonGroup3;
deleteGroup GarrisonGroup3;

_grp = [getmarkerpos "hvt_garrison_spawn_2", EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad"),[],[],[0.1,0.1]] call BIS_fnc_spawnGroup;
sleep 1;
[_grp, getMarkerPos "comm_garrison_spawn_1", 200 ] call bis_fnc_taskAttack;
sleep 1;
_grp = [getmarkerpos "hvt_garrison_spawn_3", EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad"),[],[],[0.1,0.1]] call BIS_fnc_spawnGroup;
sleep 1;
[_grp, getMarkerPos "comm_garrison_spawn_1", 200 ] call bis_fnc_taskAttack;