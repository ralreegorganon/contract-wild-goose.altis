_unit = _this select 0;

removeallweapons _unit;
removeallassigneditems _unit;
removeuniform _unit;
removevest _unit;
removebackpack _unit;

_unit addHeadgear 'H_Bandanna_khk';
_unit addVest 'V_TacVestCamo_khk';
_unit addUniform 'U_IG_Guerilla2_3';
_unit addBackPack 'B_Carryall_cbr';
_unit setFace 'AsianHead_A3_03';
_unit addGoggles 'G_Squares';

(unitBackpack _unit) additemCargo ["FirstAidKit",3];
(unitBackpack _unit) addmagazineCargo ["DemoCharge_Remote_Mag",2];

_unit addmagazine "30Rnd_556x45_Stanag";
_unit addmagazine "30Rnd_556x45_Stanag";
_unit addmagazine "30Rnd_556x45_Stanag";
_unit addmagazine "30Rnd_556x45_Stanag";
_unit addmagazine "30Rnd_556x45_Stanag";
_unit addmagazine "30Rnd_556x45_Stanag";
_unit addmagazine "30Rnd_556x45_Stanag";
_unit addmagazine "30Rnd_556x45_Stanag";

_unit addmagazine "1Rnd_HE_Grenade_shell";
_unit addmagazine "1Rnd_HE_Grenade_shell";
_unit addmagazine "1Rnd_HE_Grenade_shell";
_unit addmagazine "1Rnd_HE_Grenade_shell";
_unit addmagazine "1Rnd_HE_Grenade_shell";
_unit addmagazine "1Rnd_HE_Grenade_shell";
_unit addmagazine "1Rnd_HE_Grenade_shell";
_unit addmagazine "1Rnd_HE_Grenade_shell";
_unit addmagazine "1Rnd_HE_Grenade_shell";
_unit addmagazine "1Rnd_HE_Grenade_shell";
_unit addmagazine "1Rnd_HE_Grenade_shell";
_unit addmagazine "1Rnd_HE_Grenade_shell";

_unit addWeapon 'arifle_Mk20_GL_plain_F';
_unit addPrimaryWeaponItem 'optic_Arco';
_unit addPrimaryWeaponItem "muzzle_snds_M";

_unit addmagazine "9Rnd_45ACP_Mag";
_unit addmagazine "9Rnd_45ACP_Mag";
_unit addmagazine "9Rnd_45ACP_Mag";

_unit addWeapon 'hgun_ACPC2_snds_F';

_unit addmagazine "handgrenade";
_unit addmagazine "handgrenade";
_unit addmagazine "handgrenade";
_unit addmagazine "handgrenade";

_unit addWeapon 'launch_NLAW_F';

_unit addmagazine "NLAW_F";
_unit addmagazine "NLAW_F";
_unit addmagazine "NLAW_F";

_unit additem "ItemCompass";
_unit additem "itemgps";
_unit additem "itemmap";
_unit additem "itemradio";
_unit additem "itemwatch";
_unit additem "Rangefinder";

_unit assignitem "itemcompass";
_unit assignitem "itemgps";
_unit assignitem "itemmap";
_unit assignitem "itemradio";
_unit assignitem "itemwatch";
_unit addweapon "Rangefinder";