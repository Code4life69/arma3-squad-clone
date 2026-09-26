params ["_player", "_didJIP"];

if (hasInterface) then
{
    [_player, _didJIP] call SQC_fnc_clientInit;
}
else
{
    if (!isServer) then
    {
        [_player, _didJIP] call SQC_fnc_headlessInit;
    };
};
