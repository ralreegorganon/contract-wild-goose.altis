_target = _this select 0;  
_caller = _this select 1;  
_id = _this select 2;  
_hostage = _this select 3;

_target removeAction _id;
[_target] join _caller;
_target setCaptive true;
_target 

execVM "tasks\onCaptureHVTComplete.sqf";