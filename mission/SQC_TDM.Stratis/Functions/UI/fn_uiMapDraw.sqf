params
[
    ["_map", controlNull, [controlNull]]
];

if (!hasInterface || {isNull _map} || {isNull player}) exitWith
{
    false
};

private _mySide = side group player;
private _friendlyIcon = getText (configFile >> "CfgMarkers" >> "mil_triangle" >> "icon");

{
    if (
        alive _x
        && {_x isKindOf "CAManBase"}
        && {(side group _x) isEqualTo _mySide}
    ) then
    {
        private _isMe = _x isEqualTo player;
        private _color = if (_isMe) then
        {
            [0.95, 0.34, 0.035, 1]
        }
        else
        {
            [0.25, 0.80, 0.95, 0.95]
        };

        private _size = if (_isMe) then {22} else {16};

        _map drawIcon
        [
            _friendlyIcon,
            _color,
            getPosATL _x,
            _size,
            _size,
            direction _x,
            "",
            0,
            0.02,
            "PuristaMedium",
            "center"
        ];
    };
} forEach allUnits;

true
