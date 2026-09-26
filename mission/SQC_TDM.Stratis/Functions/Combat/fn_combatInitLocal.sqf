if (missionNamespace getVariable ["SQC_combatLocalInitialized", false]) exitWith
{
    true
};

missionNamespace setVariable ["SQC_combatLocalInitialized", true];

private _loop = [] spawn
{
    while {missionNamespace getVariable ["SQC_combatLocalInitialized", false]} do
    {
        private _regenDelay = missionNamespace getVariable ["SQC_healthRegenDelay", 5];
        private _now = diag_tickTime;

        {
            if (
                local _x
                && {alive _x}
                && {_x getVariable ["SQC_combatConfigured", false]}
                && {damage _x > 0}
            ) then
            {
                private _lastDamage = _x getVariable ["SQC_lastDamageTime", _now];

                if ((_now - _lastDamage) >= _regenDelay) then
                {
                    _x setDamage 0;
                };
            };
        } forEach allUnits;

        sleep 0.25;
    };
};

missionNamespace setVariable ["SQC_combatRegenLoop", _loop];

["COMBAT", "Local arcade combat loop initialized", "DEBUG"] call SQC_fnc_log;
true
