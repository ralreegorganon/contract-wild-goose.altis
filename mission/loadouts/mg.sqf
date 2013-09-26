_unit = _this select 0;

removeallweapons _unit;
removeallassigneditems _unit;
removeuniform _unit;
removevest _unit;
removebackpack _unit;

_unit addHeadgear 'H_Hat_brown';
_unit addVest 'V_HarnessOSpec_brn';
_unit addUniform 'U_IG_Guerilla1_1';
_unit addBackPack 'B_FieldPack_cbr';
_unit setFace 'AfricanHead_01';
_unit addGoggles 'G_Aviator';

(unitBackpack _unit) additemCargo ["FirstAidKit",3];
(unitBackpack _unit) addmagazineCargo ["DemoCharge_Remote_Mag",2];

_unit addmagazine "200Rnd_65x39_cased_Box";
_unit addmagazine "200Rnd_65x39_cased_Box";
_unit addmagazine "200Rnd_65x39_cased_Box";
_unit addmagazine "200Rnd_65x39_cased_Box";
_unit addmagazine "200Rnd_65x39_cased_Box";
_unit addmagazine "200Rnd_65x39_cased_Box_Tracer";
_unit addmagazine "200Rnd_65x39_cased_Box_Tracer";

_unit addWeapon 'LMG_Mk200_F';
_unit addPrimaryWeaponItem 'optic_Arco';
_unit addPrimaryWeaponItem "muzzle_snds_H_MG";

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