params ["_victim","_killer",["_instigator",objNull]];
if (!isServer || {!(_victim getVariable ["BL_active",false])}) exitWith {};
_victim setVariable ["BL_active",false,true];
_victim setVariable ["BL_deadAt",serverTime];
BL_spawnQueue = BL_spawnQueue - [_victim];
private _vi = BL_records findIf {(_x select 1) isEqualTo _victim};
if (_vi < 0 || {BL_phase != "ACTIVE"}) exitWith {};
private _v = BL_records select _vi;
_v set [5,(_v select 5) + 1]; _v set [7,0]; _v set [8,[]];
BL_deathHeat pushBack [getPosATL _victim,serverTime];
if (isNull _instigator) then { _instigator = _killer; };
private _killerId = _instigator getVariable ["BL_record",""];
private _ki = BL_records findIf {(_x select 0) isEqualTo _killerId};
if (_ki < 0 || {_victim isEqualTo _instigator}) exitWith {};
private _k = BL_records select _ki;
if ((_k select 2) isEqualTo (_v select 2)) exitWith {
 _k set [6,0 max ((_k select 6)-100)];
};
[_instigator,100,"ELIMINATION",true] call BL_fnc_award;
if (BL_mode isEqualTo 0) then { BL_scores set [_k select 2,(BL_scores select (_k select 2)) + 1]; };
if (BL_mode isEqualTo 3) then { BL_tags pushBack [getPosATL _victim,_v select 2,serverTime + 30]; };
// Send plain player names; clients render them with ctrlSetText/escaped structured text.
["kill",[_k select 3,_v select 3,_k select 2]] remoteExecCall ["BL_fnc_event",0];
