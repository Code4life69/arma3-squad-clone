if (!isServer || {BL_phase != "ACTIVE"}) exitWith {};
private _fighters = allUnits select {alive _x && {_x getVariable ["BL_active",false]}};
if (BL_mode isEqualTo 1) then {
 {
  _x params ["_name","_pos","_owner","_meter"];
  private _near = _fighters select {_x distance2D _pos < 18};
  private _west = {side group _x isEqualTo west} count _near;
  private _east = {side group _x isEqualTo east} count _near;
  private _next = [_owner,_meter,_west,_east] call BL_fnc_captureStep;
  _x set [2,_next select 0]; _x set [3,_next select 1]; _x set [4,_next select 2];
  if (_next select 3) then { { [_x,200,"CAPTURE"] call BL_fnc_award; } forEach _near; };
  private _contested = _next select 2;
  private _team = _x select 2;
  if (_team >= 0 && {!_contested}) then { BL_scores set [_team,(BL_scores select _team) + 1]; };
 } forEach BL_objectives;
};
if (BL_mode isEqualTo 2) then {
 if (serverTime >= BL_hillEnd) then {
  BL_hill = (BL_hill + 1) mod count BL_objectives;
  BL_hillEnd = serverTime + 60;
 };
 private _hill = BL_objectives select BL_hill;
 private _near = _fighters select {_x distance2D (_hill select 1) < 20};
 private _west = {side group _x isEqualTo west} count _near;
 private _east = {side group _x isEqualTo east} count _near;
 private _contested = _west > 0 && {_east > 0};
 _hill set [4,_contested];
 _hill set [2,-1];
 if (!_contested && {_west + _east > 0}) then {
  private _team = if (_west > 0) then {0} else {1};
  _hill set [2,_team];
  BL_scores set [_team,(BL_scores select _team) + 1];
  { [_x,10,"HARDPOINT HELD"] call BL_fnc_award; } forEach _near;
 };
};
if (BL_mode isEqualTo 3) then {
 private _remaining = [];
 {
  _x params ["_pos","_side","_expires"];
  if (_expires > serverTime) then {
   private _i = _fighters findIf {_x distance _pos < 2.8};
   if (_i < 0) then { _remaining pushBack _x; } else {
    private _collector = _fighters select _i;
    private _team = [west,east] find (side group _collector);
    if (_team isEqualTo _side) then { [_collector,25,"DENIED"] call BL_fnc_award; } else {
     BL_scores set [_team,(BL_scores select _team)+1];
     [_collector,100,"CONFIRMED"] call BL_fnc_award;
    };
   };
  };
 } forEach BL_tags;
 BL_tags = _remaining;
};
