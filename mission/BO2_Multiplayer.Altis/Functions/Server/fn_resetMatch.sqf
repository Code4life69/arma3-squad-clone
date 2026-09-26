if (!isServer) exitWith {};
BL_round = BL_round + 1;
BL_phase = "WARMUP"; BL_phaseEnd = serverTime + 15;
BL_scores = [0,0]; BL_uavUntil = [0,0]; BL_counterUntil = [0,0];
BL_recentSpawns = []; BL_deathHeat = []; BL_tags = [];
BL_hill = 0; BL_hillEnd = serverTime + 60;
// [name,ATL position,owner (-1/0/1),capture meter (-10..10),contested]
BL_objectives = [
 ["A",[3565,13125,0],-1,0,false],
 ["B",[3665,13125,0],-1,0,false],
 ["C",[3750,13040,0],-1,0,false]
];
{
 _x set [4,0]; _x set [5,0]; _x set [6,0]; _x set [7,0]; _x set [8,[]]; _x set [9,[]];
 private _unit = _x select 1;
 if (!isNull _unit && {alive _unit}) then {
  _unit setVariable ["BL_active",false,true];
  _unit setVariable ["BL_outSince",-1];
  _unit enableSimulationGlobal false;
  BL_spawnQueue pushBackUnique _unit;
 };
} forEach BL_records;
[] call BL_fnc_publish;
