params
[
    ["_headlessUnit", objNull, [objNull]],
    ["_didJIP", false, [true]]
];

if (isServer || hasInterface) exitWith
{
    ["BOOT", "headlessInit rejected on a non-headless machine", "ERROR"] call SQC_fnc_log;
    false
};

missionNamespace setVariable ["SQC_headlessUnit", _headlessUnit];
missionNamespace setVariable ["SQC_didJIP", _didJIP];
missionNamespace setVariable ["SQC_headlessReady", true];

["BOOT", format ["Headless client runtime ready; JIP=%1", _didJIP], "INFO"] call SQC_fnc_log;
true
