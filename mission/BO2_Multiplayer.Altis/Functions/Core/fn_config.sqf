// Shared immutable catalog. Networking accepts indices, never client weapon class names.
BL_center = [3660,13110,0];
BL_radius = 225;
BL_modeNames = ["TEAM DEATHMATCH","DOMINATION","HARDPOINT","KILL CONFIRMED"];
BL_limits = [75,200,250,65];
BL_primary = [
 ["ASSAULT / MX", "arifle_MX_F", "30Rnd_65x39_caseless_mag", "optic_Aco"],
 ["SMG / STING", "SMG_02_F", "30Rnd_9x21_Mag_SMG_02", "optic_Aco_smg"],
 ["SUPPORT / MK200", "LMG_Mk200_F", "200Rnd_65x39_cased_Box", "optic_Holosight"],
 ["MARKSMAN / MK18", "srifle_EBR_F", "20Rnd_762x51_Mag", "optic_DMS"],
 ["SNIPER / M320", "srifle_LRR_F", "7Rnd_408_Mag", "optic_LRPS"]
];
// Primary, optic, pistol, lethal, smoke, lightweight, toughness, scavenger, hardline.
BL_defaultClass = [0,1,1,1,1,0,1,0,0];
BL_perkNames = ["Lightweight (+8% movement)","Toughness (less aim sway)","Scavenger (nearby fallen enemies)","Hardline (+20% streak score)"];
BL_class = +BL_defaultClass;
BL_feed = [];
BL_notice = ["",0];
BL_boardHeld = false;
BL_pending = true;
