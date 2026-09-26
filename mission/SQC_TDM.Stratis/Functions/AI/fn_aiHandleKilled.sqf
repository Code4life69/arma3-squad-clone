params
[
    ["_unit", objNull, [objNull]],
    ["_killer", objNull, [objNull]],
    ["_instigator", objNull, [objNull]],
    ["_useEffects", true, [true]]
];

if (!isServer || {isNull _unit}) exitWith
{
    false
};

if !(_unit getVariable ["SQC_managedBot", false]) exitWith
{
    false
};

private _group = group _unit;
private _respawnDelay = missionNamespace getVariable ["SQC_aiRespawnDelay", 2];
private _cleanupDelay = missionNamespace getVariable ["SQC_aiCorpseCleanupDelay", 10];

[] spawn
{
    private _delay = missionNamespace getVariable ["SQC_aiRespawnDelay", 2];
    sleep _delay;
    [] call SQC_fnc_aiReconcile;
};

[_unit, _group, _cleanupDelay] spawn
{
    params ["_deadUnit", "_deadGroup", "_delay"];

    sleep _delay;

    if (!isNull _deadUnit) then
    {
        deleteVehicle _deadUnit;
    };

    if (!isNull _deadGroup && {(count units _deadGroup) isEqualTo 0}) then
    {
        deleteGroup _deadGroup;
    };
};

true
