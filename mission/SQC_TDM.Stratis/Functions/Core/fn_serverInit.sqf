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

missionNamespace setVariable ["SQC_serverReady", true];

private _built = [] call SQC_fnc_buildSpawnCandidates;

if (!_built) exitWith
{
    ["BOOT", "Spawn candidate generation failed", "ERROR"] call SQC_fnc_log;
    false
};

private _killedHandler = addMissionEventHandler
[
    "EntityKilled",
    {
        _this call SQC_fnc_recordDeathSpot;
    }
];

missionNamespace setVariable ["SQC_spawnKilledHandler", _killedHandler];

["BOOT", format ["Spawn director ready; EntityKilled EH=%1", _killedHandler], "INFO"] call SQC_fnc_log;

[] spawn
{
    sleep 1;

    {
        if (alive _x && {(side group _x) in [west, east]}) then
        {
            [_x] call SQC_fnc_placeUnitAtSpawn;
        };
    } forEach allUnits;
};

true
