params
[
    ["_unit", objNull, [objNull]],
    ["_pos", [], [[]]],
    ["_dir", 0, [0]]
];

if (isNull _unit || {_pos isEqualTo []}) exitWith
{
    false
};

if (!local _unit) exitWith
{
    ["SPAWN", "applySpawn rejected because unit is not local", "ERROR"] call SQC_fnc_log;
    false
};

_unit setPosATL _pos;
_unit setDir _dir;
_unit setVelocity [0, 0, 0];

true
