params
[
    ["_reason", "UNKNOWN", [""]]
];

if (!isServer) exitWith
{
    false
};

if !(missionNamespace getVariable ["SQC_matchRunning", false]) exitWith
{
    false
};

missionNamespace setVariable ["SQC_matchRunning", false, true];
missionNamespace setVariable ["SQC_matchState", "ENDED", true];

private _scores = missionNamespace getVariable ["SQC_matchScores", [0, 0]];
private _westScore = _scores select 0;
private _eastScore = _scores select 1;
private _ending = "TDM_DRAW";

if (_westScore > _eastScore) then
{
    _ending = "TDM_WEST_WIN";
};

if (_eastScore > _westScore) then
{
    _ending = "TDM_EAST_WIN";
};

missionNamespace setVariable ["SQC_matchResult", _ending, true];

[
    "MATCH",
    format
    [
        "TDM ended reason=%1 west=%2 east=%3 ending=%4",
        _reason,
        _westScore,
        _eastScore,
        _ending
    ],
    "INFO"
] call SQC_fnc_log;

[_ending] spawn
{
    params ["_endType"];

    sleep 3;
    _endType call BIS_fnc_endMissionServer;
};

true
