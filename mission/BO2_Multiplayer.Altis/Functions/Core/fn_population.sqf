// Target density: 12 per team in a 225 m arena; cap AI cost at 16 per team.
params ["_radius",["_requested",0]];
if (_requested > 0) exitWith {1 max (16 min (round _requested))};
6 max (16 min (round (12 * (_radius / 225) ^ 2)))
