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

    [_unit] remoteExecCall ["SQC_fnc_requestSpawn", 2];
    true
};

if !(isNil "remoteExecutedOwner") then
{
    if (remoteExecutedOwner >= 3 && {owner _unit isNotEqualTo remoteExecutedOwner}) exitWith
    {
        [
            "SPAWN",
            format
            [
                "Rejected spoofed spawn request: caller=%1 owner=%2",
                remoteExecutedOwner,
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

[_unit] call SQC_fnc_placeUnitAtSpawn
