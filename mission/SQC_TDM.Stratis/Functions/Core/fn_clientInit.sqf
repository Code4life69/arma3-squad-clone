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
true
