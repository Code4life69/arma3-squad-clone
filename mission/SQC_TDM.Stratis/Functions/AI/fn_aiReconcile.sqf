if (!isServer) exitWith
{
    false
};

private _teamSize = missionNamespace getVariable ["SQC_aiTeamSize", 6];

{
    private _side = _x;

    private _humans = allPlayers select
    {
        !(_x isKindOf "HeadlessClient_F")
        && {(side group _x) isEqualTo _side}
    };

    private _bots = allUnits select
    {
        alive _x
        && {!isPlayer _x}
        && {_x getVariable ["SQC_managedBot", false]}
        && {!(_x getVariable ["SQC_botRetiring", false])}
        && {(side group _x) isEqualTo _side}
    };

    private _targetBots = (_teamSize - (count _humans)) max 0;
    private _missing = _targetBots - (count _bots);

    if (_missing > 0) then
    {
        for "_i" from 1 to _missing do
        {
            [_side] call SQC_fnc_aiSpawnBot;
        };
    };

    private _extra = (count _bots) - _targetBots;

    if (_extra > 0) then
    {
        for "_i" from 1 to _extra do
        {
            private _index = (count _bots) - _i;

            if (_index >= 0) then
            {
                [_bots select _index] call SQC_fnc_aiRetireBot;
            };
        };
    };
} forEach [west, east];

true
