_building = _this select 0;
_x = 0;
while { format ["%1", _building buildingPos _x] != "[0,0,0]" } do {_x = _x + 1};
_x = _x - 1;
_x