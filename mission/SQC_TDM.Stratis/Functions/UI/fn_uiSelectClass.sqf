params
[
    ["_className", "ASSAULT", [""]]
];

if (!hasInterface) exitWith
{
    false
};

private _allowed = ["ASSAULT", "SMG", "LMG", "MARKSMAN", "SHOTGUN"];

if !(_className in _allowed) exitWith
{
    false
};

missionNamespace setVariable ["SQC_selectedClass", _className];
[] call SQC_fnc_uiRefreshMenu;
true
