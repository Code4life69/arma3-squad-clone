if (!hasInterface) exitWith
{
    false
};

disableSerialization;

private _display = uiNamespace getVariable ["SQC_Menu", displayNull];

if (isNull _display) exitWith
{
    false
};

private _selected = missionNamespace getVariable ["SQC_selectedClass", "ASSAULT"];

private _buttons =
[
    [7810, "ASSAULT"],
    [7811, "SMG"],
    [7812, "LMG"],
    [7813, "MARKSMAN"],
    [7814, "SHOTGUN"]
];

{
    private _ctrl = _display displayCtrl (_x select 0);
    private _name = _x select 1;

    if (_name isEqualTo _selected) then
    {
        _ctrl ctrlSetBackgroundColor [0.95, 0.34, 0.035, 0.96];
        _ctrl ctrlSetTextColor [1, 1, 1, 1];
    }
    else
    {
        _ctrl ctrlSetBackgroundColor [0.055, 0.065, 0.075, 0.88];
        _ctrl ctrlSetTextColor [0.82, 0.84, 0.86, 1];
    };
} forEach _buttons;

private _sub = "BALANCED MID-RANGE";
private _weapon = "MX 6.5 MM";
private _role = "Reliable at almost every distance. Moderate recoil, fast handling and enough range for the main streets and interiors.";

switch (_selected) do
{
    case "SMG":
    {
        _sub = "FAST CLOSE-QUARTERS";
        _weapon = "VERMIN .45 ACP";
        _role = "Built for rapid movement through rooms, alleys and short lanes. Faster-feeling handling with reduced reach.";
    };

    case "LMG":
    {
        _sub = "SUSTAINED FIRE";
        _weapon = "MX SW 6.5 MM";
        _role = "Large magazine and sustained pressure for locking down long lanes. Slower, heavier and best from prepared positions.";
    };

    case "MARKSMAN":
    {
        _sub = "PRECISION RANGE";
        _weapon = "MXM 6.5 MM";
        _role = "Accurate single-fire pressure across open streets and rooftops. Strong sightlines but less forgiving inside buildings.";
    };

    case "SHOTGUN":
    {
        _sub = "ROOM CLEARING";
        _weapon = "TACTICAL SHOTGUN";
        _role = "Extreme close-range pressure for interiors and corners. Requires aggressive routing and careful distance management.";
    };
};

(_display displayCtrl 7830) ctrlSetText _selected;
(_display displayCtrl 7831) ctrlSetText _sub;
(_display displayCtrl 7832) ctrlSetText _weapon;
(_display displayCtrl 7833) ctrlSetStructuredText parseText format
[
    "<t color='#EEF0F2' size='1.0'>%1</t><br/><br/><t color='#8E949A' size='0.78'>PRESS DEPLOY TO APPLY THIS LOADOUT.</t>",
    _role
];

true
