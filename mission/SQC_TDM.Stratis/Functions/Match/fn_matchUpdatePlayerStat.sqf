params
[
    ["_unit", objNull, [objNull]],
    ["_killDelta", 0, [0]],
    ["_deathDelta", 0, [0]]
];

if (!isServer || {isNull _unit} || {!isPlayer _unit}) exitWith
{
    false
};

private _key = getPlayerUID _unit;

if (_key isEqualTo "") then
{
    _key = format ["OWNER:%1", owner _unit];
};

private _stats = +(missionNamespace getVariable ["SQC_playerStats", []]);
private _found = -1;

{
    if ((_x select 0) isEqualTo _key) exitWith
    {
        _found = _forEachIndex;
    };
} forEach _stats;

if (_found < 0) then
{
    _stats pushBack
    [
        _key,
        name _unit,
        side group _unit,
        _killDelta max 0,
        _deathDelta max 0
    ];
}
else
{
    private _entry = +(_stats select _found);
    _entry set [1, name _unit];
    _entry set [2, side group _unit];
    _entry set [3, (_entry select 3) + _killDelta];
    _entry set [4, (_entry select 4) + _deathDelta];
    _stats set [_found, _entry];
};

missionNamespace setVariable ["SQC_playerStats", _stats, true];
true
