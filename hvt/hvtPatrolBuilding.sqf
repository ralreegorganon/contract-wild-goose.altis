sleep 0.5;

if (!isServer) exitWith {};

_unit = _this select 0;
_building = _this select 1;

_maxWaitTime = 5;
_notStuck = true;

_positionCount = [_building] call JEJ_fnc_numberPositionsInBuilding;
_newPosition = random _positionCount;
_unit setPos (_building buildingPos _newPosition) ;


while {alive _unit and _notStuck and captiveNum _unit == 0} do
{
	_newPosition = random _positionCount;
	_waitTime = random (_maxWaitTime);
	_unit doMove (_building buildingPos _newPosition);
	_unit setSpeedMode "LIMITED";
	sleep 0.5;
	_timeout = time + 80;
	waitUntil {moveToCompleted _unit or moveToFailed _unit or !alive _unit or _timeout < time};
	sleep _waitTime;
};