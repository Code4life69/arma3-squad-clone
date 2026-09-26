params
[
    ["_candidate", [], [[]]],
    ["_side", sideUnknown, [west]],
    ["_unit", objNull, [objNull]],
    ["_fullVisibilityPass", false, [true]]
];

if (!isServer) exitWith
{
    -1000000
};

if (_candidate isEqualTo [] || {!(_side in [west, east])}) exitWith
{
    -1000000
};

_candidate params ["_pos", "_type", "_building"];

private _enemySide = if (_side isEqualTo west) then {east} else {west};

private _combatants = allUnits select
{
    alive _x
    && {_x isKindOf "CAManBase"}
    && {(side group _x) in [west, east]}
    && {_x isNotEqualTo _unit}
};

private _friends = _combatants select
{
    (side group _x) isEqualTo _side
};

private _enemies = _combatants select
{
    (side group _x) isEqualTo _enemySide
};

private _nearestEnemy = 100000;
private _nearestFriend = 100000;

{
    _nearestEnemy = _nearestEnemy min (_pos distance2D _x);
} forEach _enemies;

{
    _nearestFriend = _nearestFriend min (_pos distance2D _x);
} forEach _friends;

private _hardMin = missionNamespace getVariable ["SQC_spawnEnemyHardMin", 18];

if (_nearestEnemy < _hardMin) exitWith
{
    -1000000
};

private _score = 0;

_score = _score + ((_nearestEnemy min 140) * 0.70);

if (_nearestFriend < 100000) then
{
    private _supportDelta = abs (_nearestFriend - 28);
    _score = _score + (35 - (_supportDelta min 35));
}
else
{
    _score = _score + 8;
};

if (_type isEqualTo "BUILDING") then
{
    _score = _score + 6;
};

if ((count _friends) > 0 && {(count _enemies) > 0}) then
{
    private _friendCenter = [0, 0, 0];
    private _enemyCenter = [0, 0, 0];

    {
        _friendCenter = _friendCenter vectorAdd (getPosATL _x);
    } forEach _friends;

    {
        _enemyCenter = _enemyCenter vectorAdd (getPosATL _x);
    } forEach _enemies;

    _friendCenter = _friendCenter vectorMultiply (1 / (count _friends));
    _enemyCenter = _enemyCenter vectorMultiply (1 / (count _enemies));

    private _frontVector = vectorNormalized (_enemyCenter vectorDiff _friendCenter);
    private _candidateVector = vectorNormalized (_pos vectorDiff _friendCenter);
    private _frontDot = _candidateVector vectorDotProduct _frontVector;

    if (_frontDot < -0.20) then
    {
        _score = _score + 25;
    };

    if (_frontDot > 0.45) then
    {
        _score = _score - 30;
    };
};

private _now = serverTime;
private _reuseMemory = missionNamespace getVariable ["SQC_spawnReuseMemorySeconds", 10];
private _deathMemory = missionNamespace getVariable ["SQC_spawnDeathMemorySeconds", 14];

private _recentSpawns = missionNamespace getVariable ["SQC_spawnRecent", []];

{
    _x params ["_recentPos", "_time", "_recentSide"];

    if (_recentSide isEqualTo _side) then
    {
        private _age = _now - _time;

        if (_age >= 0 && {_age < _reuseMemory}) then
        {
            private _distance = _pos distance2D _recentPos;

            if (_distance < 40) then
            {
                private _ageFactor = 1 - (_age / _reuseMemory);
                private _distanceFactor = 1 - ((_distance min 40) / 40);
                _score = _score - (70 * _ageFactor * _distanceFactor);
            };
        };
    };
} forEach _recentSpawns;

private _deathHeat = missionNamespace getVariable ["SQC_spawnDeathHeat", []];

{
    _x params ["_deathPos", "_time", "_deathSide"];

    private _age = _now - _time;

    if (_age >= 0 && {_age < _deathMemory}) then
    {
        private _distance = _pos distance2D _deathPos;

        if (_distance < 50) then
        {
            private _ageFactor = 1 - (_age / _deathMemory);
            private _distanceFactor = 1 - ((_distance min 50) / 50);
            private _sameSideFactor = if (_deathSide isEqualTo _side) then {1.15} else {0.85};

            _score = _score - (80 * _ageFactor * _distanceFactor * _sameSideFactor);
        };
    };
} forEach _deathHeat;

if (_fullVisibilityPass && {(count _enemies) > 0}) then
{
    private _losRange = missionNamespace getVariable ["SQC_spawnLOSRange", 120];
    private _spawnEyeATL = +_pos;
    _spawnEyeATL set [2, (_spawnEyeATL select 2) + 1.55];
    private _spawnEyeASL = ATLToASL _spawnEyeATL;

    private _visibleEnemies = 0;
    private _checkedEnemies = 0;

    {
        if (_checkedEnemies < 6) then
        {
            private _distance = _pos distance2D _x;

            if (_distance <= _losRange) then
            {
                _checkedEnemies = _checkedEnemies + 1;

                private _hits = lineIntersectsSurfaces
                [
                    _spawnEyeASL,
                    eyePos _x,
                    objNull,
                    _x,
                    true,
                    1,
                    "VIEW",
                    "FIRE"
                ];

                if (_hits isEqualTo []) then
                {
                    _visibleEnemies = _visibleEnemies + 1;

                    private _distanceScale = (_distance min _losRange) / _losRange;
                    _score = _score - (95 - (40 * _distanceScale));
                };
            };
        };
    } forEach _enemies;

    if (_visibleEnemies isEqualTo 0) then
    {
        _score = _score + 18;

        if (_type isEqualTo "BUILDING") then
        {
            _score = _score + 8;
        };
    };
};

_score
