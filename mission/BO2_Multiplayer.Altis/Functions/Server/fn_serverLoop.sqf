if (!isServer) exitWith {};
private _nextBots = 0;
while {true} do {
 private _humans = allPlayers select {_x isKindOf "Man" && {!(_x isKindOf "HeadlessClient_F")}};
 if (BL_phase isEqualTo "WARMUP") then {
  if (count _humans isEqualTo 0 || {({isPlayer (_x select 1) && {(_x select 1) getVariable ["BL_active",false]}} count BL_records) isEqualTo 0}) then { BL_phaseEnd = serverTime + 15; };
  if (serverTime >= BL_phaseEnd) then {
   BL_phase = "ACTIVE"; BL_phaseEnd = serverTime + BL_minutes * 60;
   BL_hillEnd = serverTime + 60;
   { private _u = _x select 1; if (alive _u && {_u getVariable ["BL_active",false]}) then { _u enableSimulationGlobal true; }; } forEach BL_records;
   ["notice",["MATCH START | WEAPONS FREE"]] remoteExecCall ["BL_fnc_event",0];
  };
 };
 if (BL_phase isEqualTo "ACTIVE") then {
  [] call BL_fnc_objectives;
  if (serverTime >= BL_phaseEnd || {((BL_scores select 0) max (BL_scores select 1)) >= BL_limit}) then {
   BL_phase = "INTERMISSION"; BL_phaseEnd = serverTime + 15;
   { private _u = _x select 1; if (alive _u) then { _u enableSimulationGlobal false; }; } forEach BL_records;
  };
 };
 if (BL_phase isEqualTo "INTERMISSION" && {serverTime >= BL_phaseEnd}) then { [] call BL_fnc_resetMatch; };
 if (BL_phase != "INTERMISSION") then {
  if (serverTime >= _nextBots) then { [] call BL_fnc_bots; _nextBots = serverTime + 4; };
  private _waiting = [];
  { if (!([_x] call BL_fnc_deploy)) then { _waiting pushBack _x; }; } forEach BL_spawnQueue;
  BL_spawnQueue = _waiting;
  {
   private _u = _x select 1;
   if (alive _u && {_u getVariable ["BL_active",false]}) then {
    if (!isPlayer _u) then { _u allowDamage (BL_phase isEqualTo "ACTIVE" && {serverTime >= (_u getVariable ["BL_protectedUntil",0])}); };
    private _outside = _u distance2D BL_center > BL_radius;
    private _since = _u getVariable ["BL_outSince",-1];
    if (_outside && {_since < 0}) then { _u setVariable ["BL_outSince",serverTime]; };
    if (!_outside && {_since >= 0}) then { _u setVariable ["BL_outSince",-1]; };
    if (_outside && {_since >= 0} && {serverTime - _since > 8}) then {
     _u setVariable ["BL_active",false,true];
     _u setVariable ["BL_delivery",[]];
     _u setVariable ["BL_confirmedDelivery",[-1,-1],true];
     _u hideObjectGlobal true;
     _u enableSimulationGlobal false;
     BL_spawnQueue pushBackUnique _u;
    };
   };
  } forEach BL_records;
 };
 BL_recentSpawns = BL_recentSpawns select {serverTime - (_x select 1) < 15};
 BL_deathHeat = BL_deathHeat select {serverTime - (_x select 1) < 20};
 [] call BL_fnc_publish;
 sleep 1;
};
