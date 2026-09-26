if (!isServer) exitWith
{
    ["SPAWN", "buildSpawnCandidates rejected on non-server", "ERROR"] call SQC_fnc_log;
    false
};

private _center = missionNamespace getVariable ["SQC_spawnArenaCenter", [2915.2, 6164.52, 0]];
private _radius = missionNamespace getVariable ["SQC_spawnArenaRadius", 230];
private _step = missionNamespace getVariable ["SQC_spawnGroundStep", 25];

private _candidates = [];
private _buildingCount = 0;
private _groundCount = 0;

private _buildings = nearestTerrainObjects
[
    _center,
    ["HOUSE", "BUILDING"],
    _radius,
    false,
    true
];

{
    private _building = _x;
    private _positions = _building buildingPos -1;

    {
        private _pos = +_x;

        if (
            (_pos distance2D _center) <= _radius
            && {!surfaceIsWater _pos}
            && {!(_pos isEqualTo [0, 0, 0])}
        ) then
        {
            private _duplicate = false;

            {
                if (((_x select 0) distance2D _pos) < 2.5) exitWith
                {
                    _duplicate = true;
                };
            } forEach _candidates;

            if (!_duplicate) then
            {
                _candidates pushBack [_pos, "BUILDING", _building];
                _buildingCount = _buildingCount + 1;
            };
        };
    } forEach _positions;
} forEach _buildings;

for "_dx" from (-_radius) to _radius step _step do
{
    for "_dy" from (-_radius) to _radius step _step do
    {
        private _seed =
        [
            (_center select 0) + _dx,
            (_center select 1) + _dy,
            0
        ];

        if ((_seed distance2D _center) <= _radius && {!surfaceIsWater _seed}) then
        {
            private _pos = _seed findEmptyPosition [1.0, 10, "B_Soldier_F"];

            if (!(_pos isEqualTo []) && {(_pos distance2D _center) <= _radius} && {!surfaceIsWater _pos}) then
            {
                _pos set [2, 0];

                private _duplicate = false;

                {
                    if (((_x select 0) distance2D _pos) < 4) exitWith
                    {
                        _duplicate = true;
                    };
                } forEach _candidates;

                if (!_duplicate) then
                {
                    _candidates pushBack [_pos, "GROUND", objNull];
                    _groundCount = _groundCount + 1;
                };
            };
        };
    };
};

if ((count _candidates) < 20) exitWith
{
    [
        "SPAWN",
        format ["Candidate generation produced only %1 positions", count _candidates],
        "ERROR"
    ] call SQC_fnc_log;

    missionNamespace setVariable ["SQC_spawnReady", false];
    false
};

missionNamespace setVariable ["SQC_spawnCandidates", _candidates];
missionNamespace setVariable ["SQC_spawnReady", true];

[
    "SPAWN",
    format
    [
        "Generated %1 candidates (%2 building, %3 ground) in Agia Marina",
        count _candidates,
        _buildingCount,
        _groundCount
    ],
    "INFO"
] call SQC_fnc_log;

true
