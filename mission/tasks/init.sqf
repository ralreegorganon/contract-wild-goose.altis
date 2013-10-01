cutText ["", "BLACK OUT", 0.001];
[ 
    ["CONTRACT:","<t align = 'center' shadow = '1' size = '0.7'>%1</t><br/>"], 
    ["WILD GOOSE","<t align = 'center' shadow = '1' size = '1.0'>%1</t><br/>"] 
] spawn JEJ_fnc_printText;  

playmusic "music1";

sleep 4;

cutText ["", "BLACK IN", 10];

sleep 5;

execvm "mission\tasks\driveToContact\init.sqf";