_unit = _this select 0;

playergroup = group _unit;  

[_unit] execvm "mission\loadouts\at.sqf";

_unit moveincargo boat; 