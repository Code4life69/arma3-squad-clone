params ["_unit"];
if (!isServer || {isNull _unit} || {!alive _unit}) exitWith {true};
if (_unit getVariable ["BL_active",false]) exitWith {true};
private _i = BL_records findIf {(_x select 1) isEqualTo _unit};
if (_i < 0) exitWith {true};
private _r = BL_records select _i;
private _delivery = _unit getVariable ["BL_delivery",[]];
// Resend the same ticket. A retry must not choose another position or refill a kit.
if (count _delivery > 0 && {(_delivery select 3) != BL_round}) then {
 _unit setVariable ["BL_delivery",[]]; _delivery = [];
};
if (count _delivery isEqualTo 0) then {
 private _spawn = [_unit,_r select 2] call BL_fnc_selectSpawn;
 if (count _spawn > 0) then {
  BL_deliverySerial = BL_deliverySerial + 1;
  _delivery = [BL_deliverySerial,_spawn,+(_r select 10),BL_round];
  _unit setVariable ["BL_delivery",_delivery];
  _unit setVariable ["BL_deliverySentAt",-10];
  _unit setVariable ["BL_outSince",-1];
  _unit setVariable ["BL_hurtAt",serverTime];
  _unit setVariable ["BL_lastDamage",0];
  _unit setVariable ["BL_class",+(_r select 10),true];
  _unit setVariable ["BL_active",false,true];
  _unit enableSimulationGlobal false;
  _unit hideObjectGlobal true;
  _r set [7,0]; _r set [8,[]];
 };
};
if (count _delivery isEqualTo 0) exitWith {
 private _nextLog = _unit getVariable ["BL_nextSpawnLog",0];
 if (serverTime >= _nextLog) then {
  diag_log format ["[BLACKLINE][RESPAWN] Waiting for safe position: life=%1 candidates=%2",netId _unit,count BL_spawns];
  _unit setVariable ["BL_nextSpawnLog",serverTime+10];
 };
 false
};
_delivery params ["_ticket","_spawn","_class","_round"];
if (isPlayer _unit) exitWith {
 // The server owns the destination; set it before delivery so a disabled unit's
 // position replication cannot leave a valid acknowledgement waiting forever.
 _unit setPosATL (_spawn select 0);
 if (serverTime - (_unit getVariable ["BL_deliverySentAt",-10]) >= 2) then {
  [_unit,_spawn,_class,_round,_ticket,netId _unit] remoteExecCall ["BL_fnc_receive",owner _unit];
  _unit setVariable ["BL_deliverySentAt",serverTime];
  BL_recentSpawns pushBack [_spawn select 0,serverTime];
 };
 false
};
_unit setPosATL (_spawn select 0); _unit setDir (_spawn select 1);
[_unit,_class] call BL_fnc_loadout;
_unit setVariable ["BL_active",true,true];
_unit setVariable ["BL_protectedUntil",serverTime+(_unit getVariable ["BL_spawnShield",1.5]),true];
_unit setVariable ["BL_delivery",[]];
_unit hideObjectGlobal false;
_unit enableSimulationGlobal (BL_phase isEqualTo "ACTIVE");
_unit allowDamage false;
true
