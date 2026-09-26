params
[
    ["_victim", objNull, [objNull]],
    ["_killer", objNull, [objNull]],
    ["_instigator", objNull, [objNull]],
    ["_useEffects", true, [true]]
];

if (!isServer) exitWith
{
    false
};

if !(missionNamespace getVariable ["SQC_matchRunning", false]) exitWith
{
    false
};

if (isNull _victim || {!(_victim isKindOf "CAManBase")}) exitWith
{
    false
};

private _victimSide = side group _victim;

if !(_victimSide in [west, east]) exitWith
{
    false
};

if (isPlayer _victim) then
{
    [_victim, 0, 1] call SQC_fnc_matchUpdatePlayerStat;
};

private _source = _killer;

if (!isNull _instigator) then
{
    _source = _instigator;
};

if (isNull _source) exitWith
{
    ["ENVIRONMENT", name _victim, "ENVIRONMENT"] call SQC_fnc_matchBroadcastKillFeed;
    true
};

private _sourceSide = if (_source isKindOf "CAManBase") then
{
    side group _source
}
else
{
    side _source
};

if !(_sourceSide in [west, east]) exitWith
{
    [name _source, name _victim, "ENVIRONMENT"] call SQC_fnc_matchBroadcastKillFeed;
    true
};

if (_source isEqualTo _victim) exitWith
{
    [name _source, name _victim, "SUICIDE"] call SQC_fnc_matchBroadcastKillFeed;
    true
};

if (_sourceSide isEqualTo _victimSide) exitWith
{
    [name _source, name _victim, "TEAMKILL"] call SQC_fnc_matchBroadcastKillFeed;
    true
};

private _scores = +(missionNamespace getVariable ["SQC_matchScores", [0, 0]]);
private _index = if (_sourceSide isEqualTo west) then {0} else {1};

_scores set [_index, (_scores select _index) + 1];
missionNamespace setVariable ["SQC_matchScores", _scores, true];

if (isPlayer _source) then
{
    [_source, 1, 0] call SQC_fnc_matchUpdatePlayerStat;
};

[name _source, name _victim, "KILL"] call SQC_fnc_matchBroadcastKillFeed;

private _scoreLimit = missionNamespace getVariable ["SQC_matchScoreLimit", 75];

if ((_scores select _index) >= _scoreLimit) then
{
    ["SCORE_LIMIT"] call SQC_fnc_matchEnd;
};

true
