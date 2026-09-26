params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];

if (hasInterface && {!isNull _newUnit}) then
{
    [_newUnit] call SQC_fnc_combatApplyUnit;
};

true
