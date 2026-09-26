params
[
    ["_side", sideUnknown, [west]],
    ["_unit", objNull, [objNull]]
];

if (!isServer) exitWith
{
    []
};

if !(_side in [west, east]) exitWith
{
    []
};

if !(missionNamespace getVariable ["SQC_spawnReady", false]) then
{
    [] call SQC_fnc_buildSpawnCandidates;
};

private _candidates = missionNamespace getVariable ["SQC_spawnCandidates", []];

if (_candidates isEqualTo []) exitWith
{
    ["SPAWN", "No spawn candidates are available", "ERROR"] call SQC_fnc_log;
    []
};

private _coarse = [];

{
    private _score = [_x, _side, _unit, false] call SQC_fnc_scoreSpawnCandidate;

    if (_score > -999999) then
    {
        _coarse pushBack [_score, _forEachIndex, _x];
    };
} forEach _candidates;

if (_coarse isEqualTo []) exitWith
{
    ["SPAWN", format ["No coarse spawn survived for %1", _side], "ERROR"] call SQC_fnc_log;
    []
};

_coarse sort false;

private _refineCount = missionNamespace getVariable ["SQC_spawnRefineCount", 24];
private _limit = (_refineCount min (count _coarse)) - 1;
private _refined = [];

for "_i" from 0 to _limit do
{
    private _candidate = (_coarse select _i) select 2;
    private _score = [_candidate, _side, _unit, true] call SQC_fnc_scoreSpawnCandidate;

    if (_score > -999999) then
    {
        _refined pushBack [_score, _i, _candidate];
    };
};

if (_refined isEqualTo []) exitWith
{
    ["SPAWN", format ["No refined spawn survived for %1", _side], "ERROR"] call SQC_fnc_log;
    []
};

_refined sort false;

private _bestScore = (_refined select 0) select 0;
private _selectionPool = [];
private _poolMaxIndex = 2 min ((count _refined) - 1);

for "_i" from 0 to _poolMaxIndex do
{
    private _entry = _refined select _i;

    if (((_entry select 0) >= (_bestScore - 12))) then
    {
        _selectionPool pushBack _entry;
    };
};

private _chosen = selectRandom _selectionPool;
_chosen params ["_chosenScore", "_rank", "_candidate"];
_candidate params ["_pos", "_type", "_building"];

private _enemySide = if (_side isEqualTo west) then {east} else {west};
private _enemies = allUnits select
{
    alive _x
    && {_x isKindOf "CAManBase"}
    && {(side group _x) isEqualTo _enemySide}
};

private _target = missionNamespace getVariable ["SQC_spawnArenaCenter", [2915.2, 6164.52, 0]];

if ((count _enemies) > 0) then
{
    private _enemyCenter = [0, 0, 0];

    {
        _enemyCenter = _enemyCenter vectorAdd (getPosATL _x);
    } forEach _enemies;

    _target = _enemyCenter vectorMultiply (1 / (count _enemies));
};

private _dx = (_target select 0) - (_pos select 0);
private _dy = (_target select 1) - (_pos select 1);
private _dir = _dx atan2 _dy;

if (_dir < 0) then
{
    _dir = _dir + 360;
};

[_pos, _dir, _chosenScore, _type]
