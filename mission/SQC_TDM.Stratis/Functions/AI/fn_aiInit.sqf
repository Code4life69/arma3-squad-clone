if (!isServer) exitWith
{
    ["AI", "aiInit rejected on non-server", "ERROR"] call SQC_fnc_log;
    false
};

if (missionNamespace getVariable ["SQC_aiInitialized", false]) exitWith
{
    true
};

missionNamespace setVariable ["SQC_aiInitialized", true];

[] call SQC_fnc_aiReconcile;

private _loop = [] spawn
{
    while {missionNamespace getVariable ["SQC_aiInitialized", false]} do
    {
        sleep 3;
        [] call SQC_fnc_aiReconcile;
    };
};

missionNamespace setVariable ["SQC_aiReconcileLoop", _loop];

[
    "AI",
    format
    [
        "AI population manager ready; target=%1 per side",
        missionNamespace getVariable ["SQC_aiTeamSize", 6]
    ],
    "INFO"
] call SQC_fnc_log;

true
