params
[
    ["_unit", objNull, [objNull]],
    ["_selection", "", [""]],
    ["_proposedDamage", 0, [0]],
    ["_source", objNull, [objNull]],
    ["_projectile", "", [""]],
    ["_hitPartIndex", -1, [0]],
    ["_instigator", objNull, [objNull]],
    ["_hitPoint", "", [""]],
    ["_directHit", 0, [0]],
    ["_context", 0, [0]]
];

if (isNull _unit || {!local _unit}) exitWith
{
    _proposedDamage
};

private _currentDamage = if (_selection isEqualTo "") then
{
    damage _unit
}
else
{
    _unit getHit _selection
};

private _attacker = _source;

if (!isNull _instigator) then
{
    _attacker = _instigator;
};

private _friendlyFire = missionNamespace getVariable ["SQC_friendlyFire", false];

if (!_friendlyFire && {!isNull _attacker} && {!(_attacker isEqualTo _unit)}) then
{
    private _attackerSide = if (_attacker isKindOf "CAManBase") then
    {
        side group _attacker
    }
    else
    {
        side _attacker
    };

    private _unitSide = side group _unit;

    if (
        _attackerSide in [west, east]
        && {_unitSide in [west, east]}
        && {_attackerSide isEqualTo _unitSide}
    ) exitWith
    {
        _currentDamage
    };
};

private _delta = (_proposedDamage - _currentDamage) max 0;

if (_delta > 0) then
{
    _unit setVariable ["SQC_lastDamageTime", diag_tickTime];
};

private _scale = missionNamespace getVariable ["SQC_damageScale", 0.86];
_currentDamage + (_delta * _scale)
