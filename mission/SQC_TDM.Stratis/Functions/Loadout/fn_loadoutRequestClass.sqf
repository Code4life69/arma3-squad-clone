params
[
    ["_unit", objNull, [objNull]],
    ["_className", "ASSAULT", [""]]
];

private _allowed = missionNamespace getVariable
[
    "SQC_loadoutClasses",
    ["ASSAULT", "SMG", "LMG", "MARKSMAN", "SHOTGUN"]
];

_className = toUpper _className;

if (isNull _unit || {!(_className in _allowed)}) exitWith
{
    false
};

if (!isServer) exitWith
{
    if (!hasInterface || {!(_unit isEqualTo player)}) exitWith
    {
        false
    };

    [_unit, _className] remoteExec ["SQC_fnc_loadoutRequestClass", 2];
    true
};

if (isRemoteExecuted) then
{
    private _caller = remoteExecutedOwner;

    if (_caller <= 2 || {(owner _unit) != _caller}) exitWith
    {
        [
            "LOADOUT",
            format ["Rejected class request caller=%1 owner=%2", _caller, owner _unit],
            "WARNING"
        ] call SQC_fnc_log;

        false
    };
};

_unit setVariable ["SQC_className", _className, true];

if (local _unit) then
{
    [_unit, _className] call SQC_fnc_loadoutApplyClass;
}
else
{
    [_unit, _className] remoteExec ["SQC_fnc_loadoutApplyClass", owner _unit];
};

true
