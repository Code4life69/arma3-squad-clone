params
[
    ["_unit", objNull, [objNull]]
];

if (isNull _unit) exitWith
{
    false
};

if (!isServer) exitWith
{
    if (!hasInterface || {_unit isNotEqualTo player}) exitWith
    {
        false
    };

    [_unit] remoteExec ["SQC_fnc_requestSpawn", 2];
    true
};

if (isRemoteExecuted) then
{
    private _callerOwner = remoteExecutedOwner;

    if (
        _callerOwner <= 2
        || {owner _unit isNotEqualTo _callerOwner}
    ) exitWith
    {
        [
            "SPAWN",
            format
            [
                "Rejected initial spawn request: caller=%1 owner=%2",
                _callerOwner,
                owner _unit
            ],
            "WARNING"
        ] call SQC_fnc_log;

        false
    };
};

if !((side group _unit) in [west, east]) exitWith
{
    false
};

if (_unit getVariable ["SQC_initialSpawnDone", false]) exitWith
{
    ["SPAWN", "Duplicate initial spawn request ignored", "DEBUG"] call SQC_fnc_log;
    false
};

_unit setVariable ["SQC_initialSpawnDone", true, true];

[_unit] call SQC_fnc_placeUnitAtSpawn
