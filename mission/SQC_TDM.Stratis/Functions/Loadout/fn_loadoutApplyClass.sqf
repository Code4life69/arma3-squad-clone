params
[
    ["_unit", objNull, [objNull]],
    ["_className", "ASSAULT", [""]]
];

if (isNull _unit || {!local _unit}) exitWith
{
    false
};

if (isRemoteExecuted && {remoteExecutedOwner != 2}) exitWith
{
    ["LOADOUT", format ["Rejected remote loadout apply from owner %1", remoteExecutedOwner], "WARNING"] call SQC_fnc_log;
    false
};

private _allowed = missionNamespace getVariable
[
    "SQC_loadoutClasses",
    ["ASSAULT", "SMG", "LMG", "MARKSMAN", "SHOTGUN"]
];

_className = toUpper _className;

if !(_className in _allowed) then
{
    _className = "ASSAULT";
};

private _weapon = "arifle_MX_F";
private _magazine = "30Rnd_65x39_caseless_mag";
private _magCount = 5;
private _optic = "optic_Holosight";

switch (_className) do
{
    case "SMG":
    {
        _weapon = "SMG_01_F";
        _magazine = "30Rnd_45ACP_Mag_SMG_01";
        _magCount = 7;
        _optic = "optic_Holosight_smg";
    };

    case "LMG":
    {
        _weapon = "LMG_Mk200_F";
        _magazine = "200Rnd_65x39_cased_Box";
        _magCount = 3;
        _optic = "optic_Holosight";
    };

    case "MARKSMAN":
    {
        _weapon = "srifle_EBR_F";
        _magazine = "20Rnd_762x51_Mag";
        _magCount = 6;
        _optic = "optic_Hamr";
    };

    case "SHOTGUN":
    {
        private _shotgunAvailable =
            isClass (configFile >> "CfgWeapons" >> "sgun_HunterShotgun_01_F")
            && {isClass (configFile >> "CfgMagazines" >> "2Rnd_12Gauge_Pellets")};

        if (_shotgunAvailable) then
        {
            _weapon = "sgun_HunterShotgun_01_F";
            _magazine = "2Rnd_12Gauge_Pellets";
            _magCount = 10;
            _optic = "";
        }
        else
        {
            _weapon = "arifle_MXC_F";
            _magazine = "30Rnd_65x39_caseless_mag";
            _magCount = 6;
            _optic = "optic_Holosight";
        };
    };
};

if !(isClass (configFile >> "CfgWeapons" >> _weapon)) exitWith
{
    ["LOADOUT", format ["Primary class missing: %1", _weapon], "ERROR"] call SQC_fnc_log;
    false
};

if !(isClass (configFile >> "CfgMagazines" >> _magazine)) exitWith
{
    ["LOADOUT", format ["Magazine class missing: %1", _magazine], "ERROR"] call SQC_fnc_log;
    false
};

removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;

_unit linkItem "ItemMap";
_unit linkItem "ItemCompass";
_unit linkItem "ItemWatch";
_unit linkItem "ItemRadio";

_unit addMagazines [_magazine, _magCount];
_unit addWeapon _weapon;

if (_optic != "" && {isClass (configFile >> "CfgWeapons" >> _optic)}) then
{
    _unit addPrimaryWeaponItem _optic;
};

if (
    isClass (configFile >> "CfgWeapons" >> "hgun_P07_F")
    && {isClass (configFile >> "CfgMagazines" >> "16Rnd_9x21_Mag")}
) then
{
    _unit addMagazines ["16Rnd_9x21_Mag", 2];
    _unit addWeapon "hgun_P07_F";
};

if (isClass (configFile >> "CfgMagazines" >> "HandGrenade")) then
{
    _unit addMagazine "HandGrenade";
};

if (isClass (configFile >> "CfgMagazines" >> "SmokeShell")) then
{
    _unit addMagazine "SmokeShell";
};

if (isClass (configFile >> "CfgWeapons" >> "FirstAidKit")) then
{
    _unit addItem "FirstAidKit";
};

_unit selectWeapon _weapon;
_unit setVariable ["SQC_className", _className, true];

if (isPlayer _unit) then
{
    private _aim = 0.55;
    private _recoil = 0.75;

    switch (_className) do
    {
        case "SMG":
        {
            _aim = 0.50;
            _recoil = 0.70;
        };

        case "LMG":
        {
            _aim = 0.70;
            _recoil = 0.90;
        };

        case "MARKSMAN":
        {
            _aim = 0.45;
            _recoil = 0.82;
        };

        case "SHOTGUN":
        {
            _aim = 0.55;
            _recoil = 0.80;
        };
    };

    _unit setCustomAimCoef _aim;
    _unit setUnitRecoilCoefficient _recoil;
};

true
