params ["_map"];
if (isNil "BL_state") exitWith {};
private _team = [west,east] find (side group player);
if (_team < 0) exitWith {};
private _jammed = ((BL_state select 10) select (1-_team)) > serverTime;
private _uav = ((BL_state select 9) select _team) > serverTime && {!_jammed};
_map drawEllipse [BL_center,BL_radius,BL_radius,0,[1,0.4,0.08,0.8],""];
if (!_jammed) then {
 {
  if (alive _x && {_x getVariable ["BL_active",false]} && {_x isEqualTo player || {side group _x isEqualTo side group player} || {_uav}}) then {
   private _color = if (_x isEqualTo player) then {[1,1,1,1]} else {if (side group _x isEqualTo side group player) then {[0.25,0.75,1,1]} else {[1,0.2,0.1,1]}};
   _map drawIcon ["\a3\ui_f\data\map\markers\military\triangle_CA.paa",_color,getPosASLVisual _x,12,12,getDirVisual _x,"",0];
  };
 } forEach allUnits;
};
if ((BL_state select 1) in [1,2]) then {
 {
  if ((BL_state select 1) isEqualTo 1 || {_forEachIndex isEqualTo (BL_state select 6)}) then {
   private _color = [[0.8,0.8,0.8,1],[0.25,0.75,1,1],[1,0.35,0.1,1]] select ((_x select 2)+1);
   _map drawIcon ["\a3\ui_f\data\map\markers\military\objective_CA.paa",_color,_x select 1,20,20,0,_x select 0,1,0.035,"RobotoCondensed"];
  };
 } forEach (BL_state select 5);
};
