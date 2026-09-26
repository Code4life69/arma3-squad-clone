params
[
    ["_side", sideUnknown, [west]]
];

if (!isServer || {!(_side in [west, east])}) exitWith
{
    objNull
};

private _className = if (_side isEqualTo west) then
{
    missionNamespace getVariable ["SQC_aiClassWest", "B_Soldier_F"]
}
else
{
    missionNamespace getVariable ["SQC_aiClassEast", "O_Soldier_F"]
};

private _center = missionNamespace getVariable ["SQC_spawnArenaCenter", [2915.2, 6164.52, 0]];
private _group = createGroup _side;

if (isNull _group) exitWith
{
    ["AI", format ["Failed to create group for %1", _side], "ERROR"] call SQC_fnc_log;
    objNull
};

_group deleteGroupWhenEmpty true;

private _unit = _group createUnit
[
    _className,
    _center,
    [],
    0,
    "NONE"
];

if (isNull _unit) exitWith
{
    deleteGroup _group;
    ["AI", format ["Failed to create bot class %1", _className], "ERROR"] call SQC_fnc_log;
    objNull
};

private _nextId = missionNamespace getVariable ["SQC_nextBotId", 1];
missionNamespace setVariable ["SQC_nextBotId", _nextId + 1];

_unit setVariable ["SQC_managedBot", true, true];
_unit setVariable ["SQC_botId", _nextId, true];
_unit setVariable ["SQC_botRetiring", false, true];

_unit setRank "PRIVATE";
_unit allowFleeing 0.05;
_unit setBehaviour "AWARE";
_unit setCombatMode "YELLOW";

_unit setSkill 0.50;
_unit setSkill ["aimingAccuracy", 0.22];
_unit setSkill ["aimingShake", 0.35];
_unit setSkill ["aimingSpeed", 0.55];
_unit setSkill ["spotDistance", 0.60];
_unit setSkill ["spotTime", 0.55];
_unit setSkill ["courage", 0.80];

[_unit] call SQC_fnc_combatApplyUnit;
[_unit] call SQC_fnc_loadoutAssignBot;
[_unit] call SQC_fnc_placeUnitAtSpawn;

[
    "AI",
    format
    [
        "Spawned bot id=%1 side=%2 owner=%3",
        _nextId,
        _side,
        owner _unit
    ],
    "INFO"
] call SQC_fnc_log;

_unit
