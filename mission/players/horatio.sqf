_unit = _this select 0;

playergroup = group _unit;  

[_unit] execvm "mission\loadouts\marksman.sqf";

_unit moveindriver boat; 