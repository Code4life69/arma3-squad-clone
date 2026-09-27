params [["_unit",objNull,[objNull]]];
if (!hasInterface || {isNull _unit}) exitWith {};
// The engine supplies the new life explicitly. Do not use an object-scoped
// boolean as a lifetime guard: respawn state may be carried over by the engine/mods.
private _deadline = diag_tickTime + 60;
waitUntil {
 uiSleep 0.05;
 (alive _unit && {local _unit} && {_unit isEqualTo player} && {netId _unit != "0:0"}) || {diag_tickTime > _deadline}
};
if (!alive _unit || {!local _unit} || {_unit != player} || {netId _unit isEqualTo "0:0"}) exitWith {
 diag_log "[BLACKLINE][RESPAWN] New local player was not ready within 60 seconds";
};
private _life = netId _unit;
if ((missionNamespace getVariable ["BL_prepareLife",""]) isEqualTo _life) exitWith {};
BL_prepareLife = _life;
BL_appliedDelivery = [-1,-1];
BL_pending = true;
_unit allowDamage false;
_unit addEventHandler ["FiredMan",{
 params ["_u","_weapon","_muzzle","_mode","_ammo","_mag","_projectile"];
 if (BL_pending || {!(_u getVariable ["BL_active",false])} || {(missionNamespace getVariable ["BL_state",["WARMUP"]]) select 0 != "ACTIVE"} || {serverTime < (_u getVariable ["BL_protectedUntil",0])}) then { deleteVehicle _projectile; };
}];
_unit addEventHandler ["HandleRating",{0}];
diag_log format ["[BLACKLINE][RESPAWN] Registering life %1",_life];
// Retries last until the server confirms that position and loadout were applied.
while {alive _unit && {netId player isEqualTo _life} && {BL_pending}} do {
 [_unit,"join",[]] remoteExecCall ["BL_fnc_request",2];
 uiSleep 2;
 private _applied = missionNamespace getVariable ["BL_appliedDelivery",[-1,-1]];
 if ((_applied select 0) > 0 && {_unit getVariable ["BL_active",false]} && {(_unit getVariable ["BL_confirmedDelivery",[-1,-1]]) isEqualTo _applied}) then { BL_pending = false; };
};
