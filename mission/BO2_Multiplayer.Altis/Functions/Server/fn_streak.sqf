params ["_index","_data"];
if (!isServer || {count _data < 1}) exitWith {};
private _choice = _data select 0;
if (!(_choice isEqualType 0) || {!(_choice in [0,1,2])}) exitWith {};
private _r = BL_records select _index;
if (!(_choice in (_r select 9))) exitWith {};
private _team = _r select 2;
private _target = [];
if (_choice isEqualTo 2) then {
 if (count _data isEqualTo 2 && {(_data select 1) isEqualType []}) then { _target = _data select 1; };
};
if (_choice isEqualTo 2 && {count _target != 3 || {(_target findIf {!(_x isEqualType 0)}) >= 0} || {_target distance2D BL_center > BL_radius} || {surfaceIsWater _target}}) exitWith {};
private _ready = _r select 9;
_ready deleteAt (_ready find _choice);
switch _choice do {
 case 0: { BL_uavUntil set [_team,serverTime + 30]; };
 case 1: { BL_counterUntil set [_team,serverTime + 30]; };
 case 2: {
  // Mission adaptation: three delayed server-created explosive impacts, not a controllable aircraft.
  [_target,_r select 1,BL_round] spawn {
   params ["_target","_caller","_round"];
   sleep 3;
   for "_n" from -1 to 1 do {
    if (BL_phase != "ACTIVE" || {BL_round != _round}) exitWith {};
    private _p = _target vectorAdd [_n*12,_n*6,0]; _p set [2,1];
    if (_p distance2D BL_center < BL_radius) then {
     private _shell = "Sh_82mm_AMOS" createVehicle _p;
     _shell setShotParents [_caller,_caller];
     _shell setVelocity [0,0,-60];
    };
    sleep 0.35;
   };
  };
 };
};
["notice",[format ["%1 CALLED IN",["UAV","COUNTER UAV","LIGHTNING STRIKE"] select _choice]]] remoteExecCall ["BL_fnc_event",0];
