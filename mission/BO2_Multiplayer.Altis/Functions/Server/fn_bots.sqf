if (!isServer) exitWith {};
{
 private _team = _forEachIndex;
 private _side = _x;
 private _humans = {isPlayer (_x select 1) && {(_x select 2) isEqualTo _team}} count BL_records;
 private _wanted = 0 max (BL_teamSize - _humans);
 private _teamBots = BL_records select {(_x select 2) isEqualTo _team && {(_x select 0) find "BOT_" isEqualTo 0}};
 while {count _teamBots > _wanted} do {
  private _r = _teamBots deleteAt (count _teamBots - 1);
  private _u = _r select 1;
  private _g = group _u;
  BL_spawnQueue = BL_spawnQueue - [_u];
  _u setVariable ["BL_active",false,true]; deleteVehicle _u; deleteGroup _g;
  BL_records deleteAt (BL_records find _r);
 };
 // Replace dead bots after at least three seconds, on this four-second director tick.
 {
  private _old = _x select 1;
  if (!alive _old && {serverTime - (_old getVariable ["BL_deadAt",0]) >= 3}) then {
   private _g = group _old;
   private _u = _g createUnit [["B_Soldier_F","O_Soldier_F"] select _team,BL_center,[],0,"NONE"];
   _x set [1,_u];
   _u setVariable ["BL_record",_x select 0];
   _u setVariable ["BL_bot",true,true];
   _u enableSimulationGlobal false;
   _u setSkill 0.65; _u setSkill ["aimingAccuracy",BL_accuracy];
   _u setSkill ["spotDistance",0.75];
   BL_spawnQueue pushBackUnique _u;
  };
 } forEach _teamBots;
 for "_n" from (count _teamBots) to (_wanted - 1) do {
  BL_botSerial = BL_botSerial + 1;
  private _id = format ["BOT_%1",BL_botSerial];
  private _g = createGroup [_side,true];
  private _u = _g createUnit [["B_Soldier_F","O_Soldier_F"] select _team,BL_center,[],0,"NONE"];
  private _class = +BL_defaultClass; _class set [0,floor random 4];
  BL_records pushBack [_id,_u,_team,format ["BOT %1",BL_botSerial],0,0,0,0,[],[],_class,0];
  _u setVariable ["BL_record",_id]; _u setVariable ["BL_bot",true,true];
  _u enableSimulationGlobal false;
  _u setSkill 0.65; _u setSkill ["aimingAccuracy",BL_accuracy];
  BL_spawnQueue pushBackUnique _u;
 };
} forEach [west,east];
{
 private _u = _x select 1;
 if (_u getVariable ["BL_bot",false] && {alive _u} && {_u getVariable ["BL_active",false]}) then {
  private _target = BL_center;
  switch BL_mode do {
   case 1: {
    private _team = _x select 2;
    private _objectives = BL_objectives select {(_x select 2) != _team};
    if (count _objectives isEqualTo 0) then { _objectives = BL_objectives; };
    _target = (selectRandom _objectives) select 1;
   };
   case 2: { _target = (BL_objectives select BL_hill) select 1; };
   case 3: { if (count BL_tags > 0) then { _target = (selectRandom BL_tags) select 0; }; };
   default {
    private _enemies = allUnits select {alive _x && {_x getVariable ["BL_active",false]} && {side group _x != side group _u}};
    if (count _enemies > 0) then { _target = getPosATL (selectRandom _enemies); };
   };
  };
  // One soldier per group avoids an AI formation leader pulling the arena bots into a blob.
  _u setBehaviour "AWARE"; _u setCombatMode "RED";
  _u setSpeedMode "FULL";
  if (BL_phase isEqualTo "ACTIVE" && {_u distance2D _target > 7}) then { _u doMove _target; };
  // Human and bot healing share a six-second damage-free delay.
  private _damage = damage _u;
  private _last = _u getVariable ["BL_lastDamage",0];
  if (_damage > _last) then { _u setVariable ["BL_hurtAt",serverTime]; };
  if (serverTime - (_u getVariable ["BL_hurtAt",serverTime]) > 6) then { _u setDamage (0 max (_damage - 0.3)); };
  _u setVariable ["BL_lastDamage",damage _u];
 };
} forEach BL_records;
