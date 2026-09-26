if (!hasInterface || {isNull player} || {!alive player}) exitWith {};
private _unit = player;
if (_unit getVariable ["BL_prepared",false]) exitWith {};
_unit setVariable ["BL_prepared",true];
BL_pending = true;
_unit allowDamage false;
_unit addEventHandler ["FiredMan",{
 params ["_u","_weapon","_muzzle","_mode","_ammo","_mag","_projectile"];
 // No invulnerable shooting during spawn protection, warmup, or pending deployment.
 if (BL_pending || {(missionNamespace getVariable ["BL_state",["WARMUP"]]) select 0 != "ACTIVE"} || {serverTime < (_u getVariable ["BL_protectedUntil",0])}) then { deleteVehicle _projectile; };
}];
_unit addEventHandler ["HandleRating",{0}];
[_unit,"join",[]] remoteExecCall ["BL_fnc_request",2];
// Retry only registration for this life; the server's deployed flag makes requests idempotent.
[_unit] spawn {
 params ["_u"];
 while {alive _u && {_u isEqualTo player} && {BL_pending}} do {
  sleep 3;
  if (BL_pending) then { [_u,"join",[]] remoteExecCall ["BL_fnc_request",2]; };
 };
};
