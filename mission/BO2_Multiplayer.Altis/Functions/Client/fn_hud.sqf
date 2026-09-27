if (!hasInterface) exitWith {};
disableSerialization;
waitUntil {sleep 0.1; !isNull (uiNamespace getVariable ["BL_hud",displayNull])};
private _hud = uiNamespace getVariable "BL_hud";
private _map = _hud displayCtrl 100;
_map ctrlAddEventHandler ["Draw",{_this call BL_fnc_drawMap}];
private _scavenged = [];
private _outsideAt = -1;
private _nextMap = 0;
BL_lastDamage = 0; BL_hurtAt = diag_tickTime;
while {!isNull _hud} do {
 private _s = missionNamespace getVariable ["BL_state",[]];
 if (count _s > 0) then {
  private _phase = _s select 0;

  private _team = [west,east] find (side group player);
  if (_team < 0) then { _team = 0; };
  private _seconds = 0 max ceil ((_s select 4) - serverTime);
  private _timer = format ["%1:%2%3",floor (_seconds / 60),if ((_seconds mod 60) < 10) then {"0"} else {""},_seconds mod 60];
  private _mine = (_s select 2) select _team;
  private _theirs = (_s select 2) select (1-_team);
  (_hud displayCtrl 101) ctrlSetStructuredText parseText format ["<t color='#ed7027' size='0.85'>%1</t><br/><t size='1.8'>%2 <t color='#777777'>/ %3</t></t><br/>%4   |   %5 TO WIN",BL_modeNames select (_s select 1),_mine,_theirs,_timer,_s select 3];
  private _weapon = currentWeapon player;
  private _weaponName = getText (configFile >> "CfgWeapons" >> _weapon >> "displayName");
  private _mag = currentMagazine player;
  private _reserve = 0;
  { if ((_x select 0) isEqualTo _mag && {!(_x select 2)}) then { _reserve = _reserve + (_x select 1); }; } forEach magazinesAmmoFull player;
  (_hud displayCtrl 102) ctrlSetStructuredText parseText format ["<t align='right' color='#bbbbbb'>%1</t><br/><t align='right' size='2'>%2 <t size='0.55' color='#a0a0a0'>/ %3</t></t><br/><t align='right' size='0.8'>F4 CLASS   TAB SCOREBOARD</t>",_weaponName,player ammo _weapon,_reserve];
  private _ri = (_s select 8) findIf {(_x select 0) isEqualTo getPlayerUID player};
  private _ready = []; private _lifeScore = 0;
  if (_ri >= 0) then { private _r = (_s select 8) select _ri; _ready = _r select 7; _lifeScore = _r select 6; };
  private _streak = format ["<t color='#ed7027'>SCORESTREAKS / %1</t><br/>",floor _lifeScore];
  {
   _streak = _streak + format ["<t color='%1'>[%2] %3 %4</t><br/>",if (_forEachIndex in _ready) then {"#ff953e"} else {"#a0a4a8"},_forEachIndex + 5,_x,[350,600,750] select _forEachIndex];
  } forEach ["UAV","COUNTER UAV","LIGHTNING"];
  (_hud displayCtrl 105) ctrlSetStructuredText parseText _streak;
  BL_feed = BL_feed select {(_x select 1) > diag_tickTime};
  private _feed = "";
  {
   private _names = ((_x select 0) select [0,2]) apply {toString ((toArray _x) apply {if (_x in [38,60,62]) then {32} else {_x}})};
   _feed = _feed + format ["<t color='#d9dfe3'>%1</t> <t color='#ed7027'> » </t> %2<br/>",_names select 0,_names select 1];
  } forEach BL_feed;
  (_hud displayCtrl 103) ctrlSetStructuredText parseText _feed;
  private _notice = if ((BL_notice select 1) > diag_tickTime) then {BL_notice select 0} else {""};
  if ((BL_pending || {!(player getVariable ["BL_active",false])}) && {alive player}) then { _notice = "FINDING A SAFE SPAWN..."; };
  if (_phase isEqualTo "WARMUP" && {!BL_pending}) then { _notice = format ["MATCH BEGINS IN %1",_seconds]; };
  if (_phase isEqualTo "INTERMISSION") then {
   _notice = format ["%1 | NEXT MATCH %2",if (_mine isEqualTo _theirs) then {"DRAW"} else {if (_mine > _theirs) then {"VICTORY"} else {"DEFEAT"}},_seconds];
  };
  if (alive player && {!BL_pending} && {_phase isEqualTo "ACTIVE"}) then {
   if (player distance2D BL_center > BL_radius) then {
    if (_outsideAt < 0) then { _outsideAt = diag_tickTime; };
    _notice = format ["RETURN TO COMBAT AREA | %1",0 max ceil (8-(diag_tickTime-_outsideAt))];
   } else { _outsideAt = -1; };
  };
  (_hud displayCtrl 104) ctrlSetStructuredText parseText format ["<t align='center' size='1.35' color='#ff9b50'>%1</t>",_notice];
  private _objective = "";
  if ((_s select 1) isEqualTo 1) then {
   { _objective = _objective + format ["%1: %2%3   ",_x select 0,["NEUTRAL","BLACK OPS","MERC"] select ((_x select 2)+1),if (_x select 4) then {" CONTESTED"} else {""}]; } forEach (_s select 5);
  };
  if ((_s select 1) isEqualTo 2) then { _objective = format ["HARDPOINT %1  |  ROTATES %2s%3",((_s select 5) select (_s select 6)) select 0,0 max ceil ((_s select 7)-serverTime),if (((_s select 5) select (_s select 6)) select 4) then {" | CONTESTED"} else {""}]; };
  if ((_s select 1) isEqualTo 3) then { _objective = "COLLECT ENEMY TAGS / DENY FRIENDLY TAGS"; };
  (_hud displayCtrl 106) ctrlSetStructuredText parseText format ["<t align='center' color='#efb37d'>%1</t>",_objective];
  private _board = BL_boardHeld || {_phase isEqualTo "INTERMISSION"};
  (_hud displayCtrl 107) ctrlShow _board;
  if (_board) then { (_hud displayCtrl 107) ctrlSetStructuredText parseText ([_s] call BL_fnc_scoreboard); };
  if (diag_tickTime >= _nextMap) then {
   _map ctrlMapAnimAdd [0,0.012,getPosATL player]; ctrlMapAnimCommit _map;
   _nextMap = diag_tickTime + 0.5;
  };
  if (alive player) then {
   if (cameraView isEqualTo "EXTERNAL") then { player switchCamera "INTERNAL"; };
   private _damage = damage player;
   if (_damage > BL_lastDamage) then { BL_hurtAt = diag_tickTime; };
   if (!BL_pending && {diag_tickTime - BL_hurtAt > 6} && {_damage > 0}) then { player setDamage (0 max (_damage-0.025)); };
   BL_lastDamage = damage player;
   private _class = player getVariable ["BL_class",BL_defaultClass];
   if ((_class select 7) isEqualTo 1 && {!BL_pending}) then {
    private _bodies = allDeadMen select {_x distance player < 2.5 && {!(_x in _scavenged)} && {side group _x != side group player}};
    if (count _bodies > 0) then {
     _scavenged pushBack (_bodies select 0);
     if (count magazines player < 10) then { player addMagazine ((BL_primary select (_class select 0)) select 2); };
    };
    _scavenged = _scavenged select {!isNull _x};
   };
  };
 };
 sleep 0.15;
};
