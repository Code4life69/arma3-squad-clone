params
[
    ["_player", objNull, [objNull]],
    ["_didJIP", false, [true]]
];

if (!hasInterface) exitWith
{
    ["BOOT", "clientInit rejected because this machine has no interface", "ERROR"] call SQC_fnc_log;
    false
};

if (isNull _player) exitWith
{
    ["BOOT", "clientInit rejected because player object is null", "ERROR"] call SQC_fnc_log;
    false
};

missionNamespace setVariable ["SQC_localPlayer", _player];
missionNamespace setVariable ["SQC_didJIP", _didJIP];
missionNamespace setVariable ["SQC_clientReady", true];

["BOOT", format ["Player runtime ready; JIP=%1", _didJIP], "INFO"] call SQC_fnc_log;
true
