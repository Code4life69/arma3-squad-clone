if (!hasInterface) exitWith
{
    false
};

if (missionNamespace getVariable ["SQC_uiInitialized", false]) exitWith
{
    true
};

missionNamespace setVariable ["SQC_uiInitialized", true];
missionNamespace setVariable ["SQC_killFeed", []];

showHUD [true, false, false, false, false, false, false, true, false, false, true];

private _layer = "SQC_HUD_LAYER" call BIS_fnc_rscLayer;
_layer cutRsc ["SQC_HUD", "PLAIN", 0, false];

private _loop = [] spawn
{
    disableSerialization;

    waitUntil
    {
        sleep 0.05;
        !isNull (uiNamespace getVariable ["SQC_HUD", displayNull])
    };

    while {hasInterface} do
    {
        [] call SQC_fnc_uiUpdateHud;
        sleep 0.15;
    };
};

missionNamespace setVariable ["SQC_uiLoop", _loop];

["UI", "BO2-style HUD shell initialized", "INFO"] call SQC_fnc_log;
true
