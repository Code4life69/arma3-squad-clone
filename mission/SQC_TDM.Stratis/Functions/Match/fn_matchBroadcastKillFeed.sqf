params
[
    ["_killerName", "", [""]],
    ["_victimName", "", [""]],
    ["_kind", "KILL", [""]]
];

if (!isServer) exitWith
{
    false
};

private _line = "";

switch (_kind) do
{
    case "KILL":
    {
        _line = format
        [
            "<t color='#69D7EF'>%1</t>  <t color='#F1F1F1'>KILLED</t>  <t color='#F27A38'>%2</t>",
            _killerName,
            _victimName
        ];
    };

    case "TEAMKILL":
    {
        _line = format
        [
            "<t color='#F0B44D'>%1</t>  <t color='#FFFFFF'>TEAMKILL</t>  %2",
            _killerName,
            _victimName
        ];
    };

    case "SUICIDE":
    {
        _line = format ["%1  <t color='#888888'>SUICIDE</t>", _victimName];
    };

    default
    {
        _line = format ["%1  <t color='#888888'>DIED</t>", _victimName];
    };
};

[_line, 5] remoteExec ["SQC_fnc_uiPushKillFeed", -2];
true
