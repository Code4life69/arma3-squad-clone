params [["_unit",objNull,[objNull]],["_action","",[""]],["_data",[],[[]]]];
if (!isServer || {!isRemoteExecuted} || {isNull _unit} || {!isPlayer _unit} || {owner _unit != remoteExecutedOwner}) exitWith {};
private _sideIndex = [west,east] find (side group _unit);
if (_sideIndex < 0) exitWith {};
private _uid = getPlayerUID _unit;
if (_uid isEqualTo "") exitWith {};
private _i = BL_records findIf {(_x select 0) isEqualTo _uid};
if (_action isEqualTo "join") exitWith {
 if (!alive _unit) exitWith {};
 if (_i < 0) then {
  BL_records pushBack [_uid,_unit,_sideIndex,name _unit,0,0,0,0,[],[],+BL_defaultClass,0];
  _i = count BL_records - 1;
 };
 private _r = BL_records select _i;
 // Repeated requests cannot teleport or refill an already deployed life.
 if ((_r select 1) isEqualTo _unit && {_unit getVariable ["BL_active",false]}) exitWith {};
 _r set [1,_unit]; _r set [2,_sideIndex]; _r set [3,name _unit];
 _unit setVariable ["BL_record",_uid];
 _unit setVariable ["BL_active",false,true];
 _unit enableSimulationGlobal false;
 BL_spawnQueue pushBackUnique _unit;
};
if (_i < 0) exitWith {};
private _r = BL_records select _i;
if ((_r select 1) != _unit || {serverTime - (_r select 11) < 0.2}) exitWith {};
_r set [11,serverTime];
if (_action isEqualTo "class") exitWith {
 if (count _data != 9 || {(_data findIf {!(_x isEqualType 0)}) >= 0}) exitWith {};
 if ((_data select 0) != floor (_data select 0) || {(_data select 0) < 0} || {(_data select 0) >= count BL_primary}) exitWith {};
 if (((_data select [1]) findIf {!(_x in [0,1])}) >= 0 || {[_data] call BL_fnc_classCost > 10}) exitWith {};
 _r set [10,+_data];
 ["notice",["CLASS SAVED | APPLIES NEXT SPAWN"]] remoteExecCall ["BL_fnc_event",owner _unit];
};
if (_action isEqualTo "streak" && {alive _unit} && {_unit getVariable ["BL_active",false]} && {BL_phase isEqualTo "ACTIVE"}) then {
 [_i,_data] call BL_fnc_streak;
};
