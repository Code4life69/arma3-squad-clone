if (isServer && hasInterface) exitWith
{
    "HOST_SERVER"
};

if (isServer) exitWith
{
    "DEDICATED_SERVER"
};

if (hasInterface) exitWith
{
    "PLAYER_CLIENT"
};

"HEADLESS_CLIENT"
