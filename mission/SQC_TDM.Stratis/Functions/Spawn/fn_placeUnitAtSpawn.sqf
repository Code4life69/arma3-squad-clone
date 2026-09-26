params
[
    ["_unit", objNull, [objNull]]
];

if (!isServer) exitWith
{
    ["SPAWN", "placeUnitAtSpawn rejected on non-server", "ERROR"] call SQC_fnc_log;
    false
};

if (isNull _unit || {!alive _unit}) exitWith
{
    false
};

private _side = side group _unit;

if !(_side in [west, east]) exitWith
{
    ["SPAWN", "Spawn request rejected for unsupported side", "WARNING"] call SQC_fnc_log;
    false
};

private _result = [_side, _unit] call SQC_fnc_selectSpawnPosition;

if (_result isEqualTo []) exitWith
{
    ["SPAWN", format ["Failed to select spawn for %1", _unit], "ERROR"] call SQC_fnc_log;
    false
};

_result params ["_pos", "_dir", "_score", "_type"];

private _recent = missionNamespace getVariable ["SQC_spawnRecent", []];
private _reuseMemory = missionNamespace getVariable ["SQC_spawnReuseMemorySeconds", 10];
private _cutoff = serverTime - _reuseMemory;

_recent = _recent select
{
    (_x select 1) >= _cutoff
};

_recent pushBack [+_pos, serverTime, _side];
missionNamespace setVariable ["SQC_spawnRecent", _recent];

if (local _unit) then
{
    [_unit, _pos, _dir] call SQC_fnc_applySpawn;
}
else
{
    [_unit, _pos, _dir] remoteExecCall ["SQC_fnc_applySpawn", owner _unit];
};

[
    "SPAWN",
    format
    [
        "Placed %1 side=%2 type=%3 score=%4 pos=%5",
        name _unit,
        _side,
        _type,
        round _score,
        _pos
    ],
    "INFO"
] call SQC_fnc_log;

true
