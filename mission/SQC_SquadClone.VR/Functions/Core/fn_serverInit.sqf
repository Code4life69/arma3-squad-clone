if (!isServer) exitWith
{
    ["BOOT", "serverInit rejected on non-server machine", "ERROR"] call SQC_fnc_log;
    false
};

if (missionNamespace getVariable ["SQC_serverReady", false]) exitWith
{
    ["BOOT", "serverInit ignored because server runtime is already ready", "WARNING"] call SQC_fnc_log;
    true
};

missionNamespace setVariable ["SQC_serverStartTime", diag_tickTime];
missionNamespace setVariable ["SQC_serverReady", true];
missionNamespace setVariable ["SQC_bootstrapComplete", true];

["BOOT", "Authoritative server runtime ready", "INFO"] call SQC_fnc_log;
true
