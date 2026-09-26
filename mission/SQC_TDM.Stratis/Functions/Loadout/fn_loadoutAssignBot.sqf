params
[
    ["_unit", objNull, [objNull]]
];

if (!isServer || {isNull _unit}) exitWith
{
    false
};

private _classes = missionNamespace getVariable
[
    "SQC_loadoutClasses",
    ["ASSAULT", "SMG", "LMG", "MARKSMAN", "SHOTGUN"]
];

private _botId = _unit getVariable ["SQC_botId", 1];
private _index = ((_botId - 1) max 0) mod (count _classes);
private _className = _classes select _index;

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
