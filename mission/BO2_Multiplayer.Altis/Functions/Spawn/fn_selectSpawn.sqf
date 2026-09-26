params ["_unit","_sideIndex"];
if (!isServer) exitWith {[]};
private _enemySide = [east,west] select _sideIndex;
private _friendSide = [west,east] select _sideIndex;
private _enemies = allUnits select {alive _x && {_x getVariable ["BL_active",false]} && {side group _x isEqualTo _enemySide}};
private _friends = allUnits select {alive _x && {_x != _unit} && {_x getVariable ["BL_active",false]} && {side group _x isEqualTo _friendSide}};
private _ranked = [];
private _anchor = BL_center vectorAdd ([[-140,0,0],[140,0,0]] select _sideIndex);
// Exhaustive cheap filtering, bounded expensive LOS tests on top 24 candidates.
{
 _x params ["_p","_indoor","_house"];
 private _nearEnemy = 9999;
 { _nearEnemy = _nearEnemy min (_x distance _p); } forEach _enemies;
 private _occupied = (allUnits findIf {alive _x && {_x != _unit} && {_x distance _p < 4}}) >= 0;
 private _reserved = (BL_recentSpawns findIf {serverTime - (_x select 1) < 4 && {(_x select 0) distance _p < 9}}) >= 0;
 if (_nearEnemy > 40 && {!_occupied} && {!_reserved} && {!_indoor || {alive _house}}) then {
  private _friendDistance = 250;
  { _friendDistance = _friendDistance min (_x distance _p); } forEach _friends;
  private _score = (_nearEnemy min 160) * 1.3 - abs (_friendDistance - 45) * 0.4;
  _score = _score - (_p distance2D _anchor) * 0.12 + random 12;
  if (_indoor) then { _score = _score + 8; };
  { if (serverTime - (_x select 1) < 15) then { _score = _score - ((50 - ((_x select 0) distance2D _p)) max 0); }; } forEach BL_deathHeat;
  { if (serverTime - (_x select 1) < 12 && {(_x select 0) distance _p < 15}) then { _score = _score - 45; }; } forEach BL_recentSpawns;
  _ranked pushBack [_score,_forEachIndex];
 };
} forEach BL_spawns;
_ranked sort false;
private _safe = [];
private _scan = _unit getVariable ["BL_spawnScan",0];
private _batch = [];
if (count _ranked > 0) then {
 for "_n" from 0 to ((count _ranked min 24)-1) do { _batch pushBack (_ranked select ((_scan+_n) mod count _ranked)); };
 _unit setVariable ["BL_spawnScan",(_scan+24) mod count _ranked];
};
{
 private _candidate = BL_spawns select (_x select 1);
 private _p = _candidate select 0;
 private _head = ATLToASL (_p vectorAdd [0,0,1.6]);
 private _visible = _enemies findIf {
  ([_x,"VIEW"] checkVisibility [eyePos _x,_head]) > 0.1
 };
 if (_visible < 0) then { _safe pushBack [_x select 0,_p]; };
 if (count _safe >= 5) exitWith {};
} forEach _batch;
// Never turn a failed safety check into a forced spawn beside an enemy. Queue and retry.
if (count _safe isEqualTo 0) exitWith {[]};
private _p = +((selectRandom (_safe select [0,3])) select 1);
_unit setVariable ["BL_spawnScan",0];
BL_recentSpawns pushBack [_p,serverTime];
[_p, _p getDir BL_center]
