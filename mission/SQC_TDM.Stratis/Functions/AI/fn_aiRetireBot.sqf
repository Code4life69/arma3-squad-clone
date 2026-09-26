params
[
    ["_unit", objNull, [objNull]]
];

if (!isServer || {isNull _unit}) exitWith
{
    false
};

if !(_unit getVariable ["SQC_managedBot", false]) exitWith
{
    false
};

if (_unit getVariable ["SQC_botRetiring", false]) exitWith
{
    false
};

_unit setVariable ["SQC_botRetiring", true, true];

private _botId = _unit getVariable ["SQC_botId", -1];
private _group = group _unit;

deleteVehicle _unit;

if (!isNull _group && {(count units _group) isEqualTo 0}) then
{
    deleteGroup _group;
};

["AI", format ["Retired bot id=%1", _botId], "INFO"] call SQC_fnc_log;
true
