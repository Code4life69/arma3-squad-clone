if (!isServer) exitWith
{
    ["BOOT", "serverInit rejected on a non-server machine", "ERROR"] call SQC_fnc_log;
    false
};

if (missionNamespace getVariable ["SQC_serverReady", false]) exitWith
{
    ["BOOT", "serverInit ignored because server runtime is already ready", "WARNING"] call SQC_fnc_log;
    true
};

private _built = [] call SQC_fnc_buildSpawnCandidates;

if (!_built) exitWith
{
    ["BOOT", "Spawn candidate generation failed", "ERROR"] call SQC_fnc_log;
    false
};

missionNamespace setVariable ["SQC_serverReady", true];

private _killedHandler = addMissionEventHandler
[
    "EntityKilled",
    {
        _this call SQC_fnc_recordDeathSpot;
        _this call SQC_fnc_matchHandleKill;
        _this call SQC_fnc_aiHandleKilled;
    }
];

private _respawnedHandler = addMissionEventHandler
[
    "EntityRespawned",
    {
        params ["_newEntity", "_oldEntity"];

        if (
            !isNull _newEntity
            && {alive _newEntity}
            && {_newEntity isKindOf "CAManBase"}
            && {(side group _newEntity) in [west, east]}
        ) then
        {
            [_newEntity] call SQC_fnc_placeUnitAtSpawn;
        };
    }
];

missionNamespace setVariable ["SQC_spawnKilledHandler", _killedHandler];
missionNamespace setVariable ["SQC_spawnRespawnedHandler", _respawnedHandler];

[] call SQC_fnc_aiInit;
[] call SQC_fnc_matchInit;

[
    "BOOT",
    format
    [
        "Runtime ready; EntityKilled EH=%1 EntityRespawned EH=%2",
        _killedHandler,
        _respawnedHandler
    ],
    "INFO"
] call SQC_fnc_log;

true
