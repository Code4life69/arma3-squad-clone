if (!hasInterface || {isNull player}) exitWith
{
    false
};

private _className = missionNamespace getVariable ["SQC_selectedClass", "ASSAULT"];
[player, _className] call SQC_fnc_loadoutRequestClass;
true
