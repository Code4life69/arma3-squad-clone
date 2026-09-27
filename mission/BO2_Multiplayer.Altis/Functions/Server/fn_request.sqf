params [["_unit",objNull,[objNull]],["_action","",[""]],["_data",[],[[]]]];
if (!isServer || {!isRemoteExecuted} || {isNull _unit} || {!isPlayer _unit} || {owner _unit != remoteExecutedOwner}) exitWith {};
if (isNil "BL_records" || {isNil "BL_spawnQueue"}) exitWith {};
private _sideIndex = [west,east] find (side group _unit);
if (_sideIndex < 0) exitWith {};
private _uid = getPlayerUID _unit;
if (_uid isEqualTo "") exitWith {};
private _i = BL_records findIf {(_x select 0) isEqualTo _uid};
if (_action isEqualTo "join") exitWith {
 if (!alive _unit) exitWith {};
 if (_i < 0) then {
  BL_records pushBack [_uid,_unit,_sideIndex,name _unit,0,0,0,0,[],[],+BL_defaultClass,0,netId _unit];
  _i = count BL_records - 1;
 };
 private _r = BL_records select _i;
 // Repeated requests cannot teleport or refill an already deployed life.
 private _sameLife = (_r param [12,""]) isEqualTo netId _unit;
 if (_sameLife && {_unit getVariable ["BL_active",false]}) exitWith {};
 if (!_sameLife) then {
  _unit setVariable ["BL_delivery",[]];
  _unit setVariable ["BL_confirmedDelivery",[-1,-1],true];
 };
 _r set [12,netId _unit];
 _r set [1,_unit]; _r set [2,_sideIndex]; _r set [3,name _unit];
 _unit setVariable ["BL_record",_uid];
 _unit setVariable ["BL_active",false,true];
 _unit enableSimulationGlobal false;
 _unit hideObjectGlobal true;
 BL_spawnQueue pushBackUnique _unit;
};
if (_i < 0) exitWith {};
private _r = BL_records select _i;
if ((_r select 1) != _unit) exitWith {};
// Deployment acknowledgements bypass the class/streak throttle: join and ACK may
// arrive in one tick. Ownership and a server-issued ticket still gate this path.
if (_action isEqualTo "deployed") exitWith {
 if (!alive _unit || {count _data != 2} || {(_data findIf {!(_x isEqualType 0)}) >= 0}) exitWith {};
 private _delivery = _unit getVariable ["BL_delivery",[]];
 if (count _delivery != 4) exitWith {};
 _delivery params ["_ticket","_spawn","_class","_round"];
 if (!([_ticket,_round,_data select 0,_data select 1,BL_round] call BL_fnc_deploymentAckValid)) exitWith {};
 // Position replication can lag the ACK; the same ticket will be resent safely.
 if (_unit distance (_spawn select 0) > 8) exitWith {};
 _unit setVariable ["BL_protectedUntil",serverTime+1.5,true];
 _unit setVariable ["BL_confirmedDelivery",[_ticket,_round],true];
 _unit setVariable ["BL_active",true,true];
 _unit setVariable ["BL_delivery",[]];
 _unit hideObjectGlobal false;
 _unit enableSimulationGlobal (BL_phase isEqualTo "ACTIVE");
 // Do not mutate BL_spawnQueue while deploy is iterating it. Next tick removes this life.
 diag_log format ["[BLACKLINE][RESPAWN] Confirmed delivery %1 for life %2",_ticket,netId _unit];
};
if (serverTime - (_r select 11) < 0.2) exitWith {};
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
