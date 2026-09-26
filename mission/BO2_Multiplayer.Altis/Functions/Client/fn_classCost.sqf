params ["_class"];
private _cost = 1;
{ _cost = _cost + _x; } forEach (_class select [1,8]);
// A second perk occupies a wildcard allocation; three and four remain legal only within ten.
private _perks = 0;
{ _perks = _perks + _x; } forEach (_class select [5,4]);
_cost + (0 max (_perks - 1))
