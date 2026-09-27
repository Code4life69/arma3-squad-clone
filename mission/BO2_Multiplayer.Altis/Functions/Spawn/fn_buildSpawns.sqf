// Cache geometry once. Buildings retain their authored ATL floor height.
if (!isServer) exitWith {};
BL_spawns = [];
private _houses = nearestObjects [BL_center,["House"],BL_radius];
{
 private _house = _x;
 {
  private _p = _x;
  if (_p distance2D BL_center < BL_radius - 15 && {_p select 2 < 9} && {_p select 2 > -0.5}) then {
   private _feet = ATLToASL (_p vectorAdd [0,0,0.15]);
   private _head = ATLToASL (_p vectorAdd [0,0,1.8]);
   if (!lineIntersects [_feet,_head,objNull,objNull] && {!surfaceIsWater _p}) then {
    BL_spawns pushBack [_p,true,_house];
   };
  };
 } forEach (_house buildingPos -1);
} forEach _houses;
for "_xoff" from -200 to 200 step 25 do {
 for "_yoff" from -200 to 200 step 25 do {
  private _p = BL_center vectorAdd [_xoff,_yoff,0];
  if (_p distance2D BL_center < BL_radius - 15 && {!surfaceIsWater _p} && {(surfaceNormal _p) select 2 > 0.9}) then {
   private _empty = _p findEmptyPosition [0,8,"B_Soldier_F"];
   if (count _empty > 0 && {!surfaceIsWater _empty} && {(surfaceNormal _empty) select 2 > 0.9} && {_empty distance2D BL_center < BL_radius - 15}) then {
    _empty set [2,0]; BL_spawns pushBack [_empty,false,objNull];
   };
  };
 };
};
