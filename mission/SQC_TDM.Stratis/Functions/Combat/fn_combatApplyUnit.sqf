params
[
    ["_unit", objNull, [objNull]]
];

if (isNull _unit || {!local _unit}) exitWith
{
    false
};

if (_unit getVariable ["SQC_combatConfigured", false]) exitWith
{
    true
};

_unit enableStamina false;

if (isPlayer _unit) then
{
    _unit setCustomAimCoef (missionNamespace getVariable ["SQC_playerAimCoef", 0.55]);
    _unit setUnitRecoilCoefficient (missionNamespace getVariable ["SQC_playerRecoilCoef", 0.75]);
};

private _handleDamageId = _unit addEventHandler
[
    "HandleDamage",
    {
        _this call SQC_fnc_combatHandleDamage
    }
];

_unit setVariable ["SQC_combatHandleDamageId", _handleDamageId];
_unit setVariable ["SQC_lastDamageTime", diag_tickTime];
_unit setVariable ["SQC_combatConfigured", true];

true
