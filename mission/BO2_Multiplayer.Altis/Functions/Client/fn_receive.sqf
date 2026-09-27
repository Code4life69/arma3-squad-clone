params ["_unit","_spawn","_class","_round","_ticket","_life"];
if (netId player != _life || {!hasInterface} || {!isRemoteExecuted} || {remoteExecutedOwner != 2} || {_unit != player} || {!local _unit} || {!alive _unit}) exitWith {};
private _applied = missionNamespace getVariable ["BL_appliedDelivery",[-1,-1]];
private _action = [_applied select 0,_applied select 1,_ticket,_round] call BL_fnc_deliveryAction;
if (_action isEqualTo 0) exitWith {};
// Duplicate delivery acknowledges again without teleporting or refilling ammunition.
if (_action isEqualTo 2) then {
 BL_pending = true;
 _unit allowDamage false;
 _unit setPosATL (_spawn select 0); _unit setDir (_spawn select 1);
 [_unit,_class] call BL_fnc_loadout;
 BL_class = +_class;
 BL_appliedDelivery = [_ticket,_round];
 BL_lastDamage = 0; BL_hurtAt = diag_tickTime;
 diag_log format ["[BLACKLINE][RESPAWN] Applied delivery %1 to life %2",_ticket,netId _unit];
};
[_unit,"deployed",[_ticket,_round]] remoteExecCall ["BL_fnc_request",2];
