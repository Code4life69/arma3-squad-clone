if (!hasInterface) exitWith
{
    false
};

disableSerialization;

private _display = uiNamespace getVariable ["SQC_HUD", displayNull];

if (isNull _display) exitWith
{
    false
};

private _scores = missionNamespace getVariable ["SQC_matchScores", [0, 0]];
private _remaining = missionNamespace getVariable ["SQC_matchTimeRemaining", 600];
private _scoreLimit = missionNamespace getVariable ["SQC_matchScoreLimit", 75];

private _westScore = _scores select 0;
private _eastScore = _scores select 1;
private _mySide = side group player;

private _friendlyScore = if (_mySide isEqualTo east) then {_eastScore} else {_westScore};
private _enemyScore = if (_mySide isEqualTo east) then {_westScore} else {_eastScore};

private _mins = floor (_remaining / 60);
private _secs = floor (_remaining mod 60);
private _secsText = if (_secs < 10) then
{
    format ["0%1", _secs]
}
else
{
    str _secs
};

(_display displayCtrl 7722) ctrlSetText format ["%1:%2", _mins, _secsText];
(_display displayCtrl 7725) ctrlSetText str _friendlyScore;
(_display displayCtrl 7726) ctrlSetText str _enemyScore;
(_display displayCtrl 7727) ctrlSetText format ["%1 POINTS TO WIN", _scoreLimit];

private _state = "TIED";
private _stateColor = [0.72, 0.74, 0.76, 1];

if (_friendlyScore > _enemyScore) then
{
    _state = "WINNING";
    _stateColor = [0.25, 0.80, 0.95, 1];
};

if (_friendlyScore < _enemyScore) then
{
    _state = "LOSING";
    _stateColor = [0.95, 0.34, 0.035, 1];
};

private _stateCtrl = _display displayCtrl 7723;
_stateCtrl ctrlSetText _state;
_stateCtrl ctrlSetTextColor _stateColor;

private _weapon = currentWeapon player;
private _weaponName = "UNARMED";
private _loaded = 0;
private _reserve = 0;
private _fireMode = "";

if (_weapon != "") then
{
    _weaponName = getText (configFile >> "CfgWeapons" >> _weapon >> "displayName");
    private _muzzle = currentMuzzle player;

    if (_muzzle != "") then
    {
        _loaded = player ammo _muzzle;
    };

    private _currentMag = currentMagazine player;
    private _magazines = magazinesAmmoFull player;

    {
        private _magClass = _x select 0;
        private _rounds = _x select 1;
        private _isLoaded = _x select 2;

        if (_magClass isEqualTo _currentMag && {!_isLoaded}) then
        {
            _reserve = _reserve + _rounds;
        };
    } forEach _magazines;

    _fireMode = toUpper (currentWeaponMode player);

    if (_fireMode isEqualTo "FULLAUTO") then
    {
        _fireMode = "FULL-AUTO";
    };
};

(_display displayCtrl 7742) ctrlSetText toUpper _weaponName;
(_display displayCtrl 7743) ctrlSetText _fireMode;
(_display displayCtrl 7744) ctrlSetText str _loaded;
(_display displayCtrl 7746) ctrlSetText str _reserve;

private _feed = missionNamespace getVariable ["SQC_killFeed", []];
private _now = diag_tickTime;
private _liveFeed = [];
private _feedText = "";

{
    private _line = _x select 0;
    private _expires = _x select 1;

    if (_expires > _now) then
    {
        _liveFeed pushBack _x;
        _feedText = _feedText + format ["<t shadow='2'>%1</t><br/>", _line];
    };
} forEach _feed;

missionNamespace setVariable ["SQC_killFeed", _liveFeed];
(_display displayCtrl 7710) ctrlSetStructuredText parseText _feedText;

private _map = _display displayCtrl 7703;

if (!isNull _map && {!isNull player}) then
{
    _map ctrlMapAnimAdd [0, 0.060, getPosATL player];
    ctrlMapAnimCommit _map;
};

true
