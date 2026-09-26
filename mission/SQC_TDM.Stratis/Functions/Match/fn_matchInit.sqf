if (!isServer) exitWith
{
    ["MATCH", "matchInit rejected on non-server", "ERROR"] call SQC_fnc_log;
    false
};

if (missionNamespace getVariable ["SQC_matchInitialized", false]) exitWith
{
    true
};

missionNamespace setVariable ["SQC_matchInitialized", true];
missionNamespace setVariable ["SQC_matchScores", [0, 0], true];
missionNamespace setVariable ["SQC_matchState", "RUNNING", true];
missionNamespace setVariable ["SQC_matchRunning", true, true];
missionNamespace setVariable ["SQC_playerStats", [], true];

private _timeLimit = missionNamespace getVariable ["SQC_matchTimeLimit", 600];
private _scoreLimit = missionNamespace getVariable ["SQC_matchScoreLimit", 75];

missionNamespace setVariable ["SQC_matchTimeRemaining", _timeLimit, true];
missionNamespace setVariable ["SQC_matchScoreLimit", _scoreLimit, true];
missionNamespace setVariable ["SQC_matchEndTime", serverTime + _timeLimit];

private _loop = [] spawn
{
    private _lastPublished = -1;

    while {missionNamespace getVariable ["SQC_matchRunning", false]} do
    {
        private _endTime = missionNamespace getVariable ["SQC_matchEndTime", serverTime];
        private _remaining = ceil ((_endTime - serverTime) max 0);

        if (_remaining != _lastPublished) then
        {
            _lastPublished = _remaining;
            missionNamespace setVariable ["SQC_matchTimeRemaining", _remaining, true];
        };

        if (_remaining <= 0) exitWith
        {
            ["TIME_LIMIT"] call SQC_fnc_matchEnd;
        };

        sleep 0.20;
    };
};

missionNamespace setVariable ["SQC_matchTimerLoop", _loop];

[
    "MATCH",
    format ["TDM started: scoreLimit=%1 timeLimit=%2", _scoreLimit, _timeLimit],
    "INFO"
] call SQC_fnc_log;

true
