params ["_unit","_points",["_label",""],["_kill",false]];
private _id = _unit getVariable ["BL_record",""];
private _i = BL_records findIf {(_x select 0) isEqualTo _id};
if (_i < 0) exitWith {};
private _r = BL_records select _i;
_r set [6,(_r select 6) + _points];
if (_kill) then { _r set [4,(_r select 4) + 1]; };
// Posthumous explosions retain score/kill credit without feeding a new life's streak.
if (alive _unit && {(_r select 1) isEqualTo _unit}) then {
private _multiplier = if (((_r select 10) select 8) isEqualTo 1) then {1.2} else {1};
_r set [7,(_r select 7) + _points * _multiplier];
{
 if ((_r select 7) >= _x && {!(_forEachIndex in (_r select 8))}) then {
  (_r select 8) pushBack _forEachIndex;
  (_r select 9) pushBackUnique _forEachIndex;
 };
} forEach [350,600,750];
};
private _current = _r select 1;
if (isPlayer _current) then {
 ["award",[_points,_label]] remoteExecCall ["BL_fnc_event",owner _current];
};
