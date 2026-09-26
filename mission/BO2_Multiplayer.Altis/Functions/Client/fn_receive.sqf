params ["_unit","_spawn","_class","_round"];
if (!hasInterface || {!isRemoteExecuted} || {remoteExecutedOwner != 2} || {_unit != player} || {!local _unit} || {!alive _unit}) exitWith {};
BL_pending = false;
_unit allowDamage false;
_unit setPosATL (_spawn select 0); _unit setDir (_spawn select 1);
[_unit,_class] call BL_fnc_loadout;
BL_class = +_class;
BL_notice = ["DEPLOYED | SPAWN PROTECTION",diag_tickTime + 1.5];
BL_lastDamage = 0; BL_hurtAt = diag_tickTime;
[_unit,_round] spawn {
 params ["_u","_round"];
 sleep 1.5;
 if (alive _u && {_u isEqualTo player}) then { _u allowDamage true; };
};
