params ["_unit"];
if (!isServer || {isNull _unit} || {!alive _unit}) exitWith {true};
private _i = BL_records findIf {(_x select 1) isEqualTo _unit};
if (_i < 0) exitWith {true};
private _r = BL_records select _i;
private _spawn = [_unit,_r select 2] call BL_fnc_selectSpawn;
if (count _spawn isEqualTo 0) exitWith {false};
_r set [7,0]; _r set [8,[]];
_unit setVariable ["BL_class",+(_r select 10),true];
_unit setVariable ["BL_outSince",-1];
_unit setVariable ["BL_hurtAt",serverTime];
_unit setVariable ["BL_lastDamage",0];
_unit setVariable ["BL_firedAt",-100,true];
_unit setVariable ["BL_active",true,true];
_unit setVariable ["BL_protectedUntil",serverTime + 1.5,true];
_unit enableSimulationGlobal (BL_phase isEqualTo "ACTIVE");
if (isPlayer _unit) then {
 [_unit,_spawn,_r select 10,BL_round] remoteExecCall ["BL_fnc_receive",owner _unit];
} else {
 _unit setPosATL (_spawn select 0); _unit setDir (_spawn select 1);
 [_unit,_r select 10] call BL_fnc_loadout;
 _unit allowDamage false;
 [_unit] spawn { params ["_u"]; sleep 1.5; if (!isNull _u) then { _u allowDamage (BL_phase isEqualTo "ACTIVE"); }; };
};
true
