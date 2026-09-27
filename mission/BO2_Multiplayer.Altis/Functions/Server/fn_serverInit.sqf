if (!isServer || {missionNamespace getVariable ["BL_started",false]}) exitWith {};
BL_started = true;
BL_mode = ["Mode",0] call BIS_fnc_getParamValue;
BL_teamSize = [BL_radius,["TeamSize",0] call BIS_fnc_getParamValue] call BL_fnc_population;
diag_log format ["[BLACKLINE] Population target: %1 per team; radius=%2",BL_teamSize,BL_radius];
BL_minutes = ["Minutes",10] call BIS_fnc_getParamValue;
BL_accuracy = (["Difficulty",25] call BIS_fnc_getParamValue) / 100;
BL_limit = BL_limits select BL_mode;
BL_records = []; // [id,unit,sideIndex,name,kills,deaths,score,lifeScore,earned[],ready[],class[],lastRequest]
BL_recentSpawns = [];
BL_deathHeat = [];
BL_tags = [];
BL_botSerial = 0;
BL_deliverySerial = 0;
BL_round = 0;
BL_uavUntil = [0,0];
BL_counterUntil = [0,0];
BL_spawnQueue = [];
west setFriend [east,0]; east setFriend [west,0];
createMarker ["BL_arena",BL_center]; "BL_arena" setMarkerShape "ELLIPSE";
"BL_arena" setMarkerSize [BL_radius,BL_radius]; "BL_arena" setMarkerBrush "Border";
"BL_arena" setMarkerColor "ColorOrange";
[] call BL_fnc_buildSpawns;
if (count BL_spawns isEqualTo 0) then {
 diag_log "[BLACKLINE][ERROR] No spawn candidates. Check Altis mission folder and arena geometry.";
};
// Engine respawn staging must use geometry-checked land, not coastal constants.
private _ground = BL_spawns select {!(_x select 1)};
if (count _ground > 0) then {
 {
  private _anchor = BL_center vectorAdd _x;
  private _ranked = _ground apply {[(_x select 0) distance2D _anchor,_forEachIndex]};
  _ranked sort true;
  private _position = (_ground select ((_ranked select 0) select 1)) select 0;
  private _name = ["respawn_west","respawn_east"] select _forEachIndex;
  if (!(_name in allMapMarkers)) then { createMarker [_name,_position]; };
  _name setMarkerPos _position; _name setMarkerType "Empty";
  diag_log format ["[BLACKLINE][RESPAWN] Land staging %1: %2",_name,_position];
 } forEach [[-140,0,0],[140,0,0]];
} else {
 diag_log "[BLACKLINE][ERROR] No checked ground staging positions; inspect arena geometry.";
};
[] call BL_fnc_resetMatch;
addMissionEventHandler ["EntityKilled",{ _this call BL_fnc_killed; }];
addMissionEventHandler ["HandleDisconnect",{
 params ["_unit","_id","_uid"];
 private _i = BL_records findIf {(_x select 0) isEqualTo _uid};
 if (_i >= 0) then { BL_records deleteAt _i; };
 BL_spawnQueue = BL_spawnQueue - [_unit];
 deleteVehicle _unit;
 true
}];
[] spawn BL_fnc_serverLoop;
diag_log format ["[BLACKLINE] Server ready: %1 spawn candidates, mode %2",count BL_spawns,BL_mode];
