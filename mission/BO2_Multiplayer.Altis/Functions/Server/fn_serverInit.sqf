if (!isServer || {missionNamespace getVariable ["BL_started",false]}) exitWith {};
BL_started = true;
BL_mode = ["Mode",0] call BIS_fnc_getParamValue;
BL_teamSize = ["TeamSize",6] call BIS_fnc_getParamValue;
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
{
 private _name = ["respawn_west","respawn_east"] select _forEachIndex;
 if (!( _name in allMapMarkers)) then { createMarker [_name,_x]; };
 _name setMarkerPos _x; _name setMarkerType "Empty";
} forEach [[3520,13110,0],[3800,13110,0]];
createMarker ["BL_arena",BL_center]; "BL_arena" setMarkerShape "ELLIPSE";
"BL_arena" setMarkerSize [BL_radius,BL_radius]; "BL_arena" setMarkerBrush "Border";
"BL_arena" setMarkerColor "ColorOrange";
[] call BL_fnc_buildSpawns;
if (count BL_spawns isEqualTo 0) then {
 diag_log "[BLACKLINE][ERROR] No spawn candidates. Check Altis mission folder and arena geometry.";
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
