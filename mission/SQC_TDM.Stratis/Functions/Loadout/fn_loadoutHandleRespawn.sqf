params
[
    ["_newUnit", objNull, [objNull]],
    ["_oldUnit", objNull, [objNull]]
];

if (!isServer || {isNull _newUnit}) exitWith
{
    false
};

private _className = "ASSAULT";

if (!isNull _oldUnit) then
{
    _className = _oldUnit getVariable ["SQC_className", "ASSAULT"];
};

_newUnit setVariable ["SQC_className", _className, true];

if (local _newUnit) then
{
    [_newUnit, _className] call SQC_fnc_loadoutApplyClass;
}
else
{
    [_newUnit, _className] remoteExec ["SQC_fnc_loadoutApplyClass", owner _newUnit];
};

true
