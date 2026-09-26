params
[
    ["_line", "", [""]],
    ["_lifetime", 5, [0]]
];

if (!hasInterface || {_line isEqualTo ""}) exitWith
{
    false
};

private _feed = missionNamespace getVariable ["SQC_killFeed", []];
_feed pushBack [_line, diag_tickTime + (_lifetime max 1)];

while {(count _feed) > 5} do
{
    _feed deleteAt 0;
};

missionNamespace setVariable ["SQC_killFeed", _feed];
true
