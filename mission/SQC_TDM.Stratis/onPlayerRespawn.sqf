params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];

if (!hasInterface || {isNull _newUnit}) exitWith
{
    false
};

[_newUnit] call SQC_fnc_requestSpawn;
true
