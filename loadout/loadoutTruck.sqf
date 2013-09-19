_unit = _this select 0;
clearWeaponCargo _unit;
clearMagazineCargo _unit;
clearItemCargo _unit;

_unit addMagazineCargo ["30Rnd_556x45_Stanag",10];
_unit addMagazineCargo ["20Rnd_762x51_Mag",10];
_unit addMagazineCargo ["200Rnd_65x39_cased_Box",5];
_unit addMagazineCargo ["200Rnd_65x39_cased_Box_Tracer",5];
_unit addMagazineCargo ["9Rnd_45ACP_Mag",6];
_unit addMagazineCargo ["NLAW_F",5];
_unit addMagazineCargo ["handgrenade",8];
_unit addMagazineCargo ["1Rnd_HE_Grenade_shell",20];
_unit addWeaponCargo ["launch_NLAW_F",1];
_unit additemCargo ["FirstAidKit",12];