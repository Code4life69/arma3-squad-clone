params
[
    ["_player", objNull, [objNull]],
    ["_didJIP", false, [true]]
];

if (!hasInterface) exitWith
{
    false
};

if (isNull _player) exitWith
{
    ["BOOT", "Client init received a null player object", "ERROR"] call SQC_fnc_log;
    false
};

missionNamespace setVariable ["SQC_localPlayer", _player];
missionNamespace setVariable ["SQC_didJIP", _didJIP];

["BOOT", format ["Client ready; JIP=%1", _didJIP], "INFO"] call SQC_fnc_log;

[] call SQC_fnc_uiInit;

[_player] spawn
{
    params ["_unit"];

    if (isServer) then
    {
        waitUntil
        {
            sleep 0.05;
            missionNamespace getVariable ["SQC_spawnReady", false]
        };
    }
    else
    {
        sleep 0.10;
    };

    if (!isNull _unit && {alive _unit}) then
    {
        [_unit] call SQC_fnc_requestSpawn;
    };

    waitUntil
    {
        sleep 0.05;
        !isNull (findDisplay 46)
    };

    sleep 0.20;
    [] call SQC_fnc_uiOpenMenu;
};

true
