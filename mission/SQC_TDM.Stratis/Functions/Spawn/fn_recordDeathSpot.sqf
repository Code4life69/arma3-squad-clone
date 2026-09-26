params
[
    ["_unit", objNull, [objNull]],
    ["_killer", objNull, [objNull]],
    ["_instigator", objNull, [objNull]],
    ["_useEffects", true, [true]]
];

if (!isServer || {isNull _unit} || {!(_unit isKindOf "CAManBase")}) exitWith
{
    false
};

private _side = side group _unit;

if !(_side in [west, east]) exitWith
{
    false
};

private _history = missionNamespace getVariable ["SQC_spawnDeathHeat", []];
private _memory = missionNamespace getVariable ["SQC_spawnDeathMemorySeconds", 14];
private _cutoff = serverTime - _memory;

_history = _history select
{
    (_x select 1) >= _cutoff
};

_history pushBack [getPosATL _unit, serverTime, _side];
missionNamespace setVariable ["SQC_spawnDeathHeat", _history];

true
