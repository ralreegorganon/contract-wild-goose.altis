_unit = _this select 0;

removeallweapons _unit;
removeallassigneditems _unit;
removeuniform _unit;
removevest _unit;
removebackpack _unit;

_unit addHeadgear "H_Watchcap_camo";
_unit addVest "V_TacVest_camo";
_unit addBackPack "B_AssaultPack_mcamo";
_unit setFace 'GreekHead_A3_03';
_unit addGoggles 'G_Shades_Black';
_unit addUniform 'U_IG_leader';

(unitBackpack _unit) additemCargo ["FirstAidKit",3];
(unitBackpack _unit) addmagazineCargo ["DemoCharge_Remote_Mag",2];

_unit addmagazine "20Rnd_762x51_Mag";
_unit addmagazine "20Rnd_762x51_Mag";
_unit addmagazine "20Rnd_762x51_Mag";
_unit addmagazine "20Rnd_762x51_Mag";
_unit addmagazine "20Rnd_762x51_Mag";
_unit addmagazine "20Rnd_762x51_Mag";
_unit addmagazine "20Rnd_762x51_Mag";
_unit addmagazine "20Rnd_762x51_Mag";
_unit addmagazine "20Rnd_762x51_Mag";
_unit addmagazine "20Rnd_762x51_Mag";
_unit addmagazine "20Rnd_762x51_Mag";

_unit addWeapon 'srifle_EBR_F';
_unit addPrimaryWeaponItem 'optic_Arco';
_unit addPrimaryWeaponItem "muzzle_snds_B";

_unit addmagazine "9Rnd_45ACP_Mag";
_unit addmagazine "9Rnd_45ACP_Mag";
_unit addmagazine "9Rnd_45ACP_Mag";

_unit addWeapon 'hgun_ACPC2_snds_F';

_unit addmagazine "handgrenade";
_unit addmagazine "handgrenade";
_unit addmagazine "handgrenade";
_unit addmagazine "handgrenade";

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
