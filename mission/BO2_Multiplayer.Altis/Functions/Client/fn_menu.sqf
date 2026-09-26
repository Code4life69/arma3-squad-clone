if (!hasInterface || {dialog}) exitWith {};
disableSerialization;
BL_boardHeld = false;
createDialog "BL_Menu";
private _d = findDisplay 8800;
uiNamespace setVariable ["BL_menu",_d];
BL_editClass = +BL_class;
// Coordinates use safeZone fractions so the lobby scales on widescreen displays.
private _make = {
 params ["_type","_id","_rect",["_text",""]];
 private _c = _d ctrlCreate [_type,_id];
 _c ctrlSetPosition [safeZoneX+(_rect select 0)*safeZoneW,safeZoneY+(_rect select 1)*safeZoneH,(_rect select 2)*safeZoneW,(_rect select 3)*safeZoneH];
 _c ctrlSetText _text; _c ctrlCommit 0; _c
};
private _bg = ["BL_Text",1,[0,0,1,1]] call _make; _bg ctrlSetBackgroundColor [0.018,0.023,0.028,0.97];
private _stripe = ["BL_Text",2,[0.045,0.12,0.91,0.004]] call _make; _stripe ctrlSetBackgroundColor [0.95,0.35,0.05,1];
private _title = ["BL_Text",3,[0.045,0.04,0.85,0.06],"BLACKLINE  //  MULTIPLAYER"] call _make;
_title ctrlSetFont "RobotoCondensedBold"; _title ctrlSetFontHeight 0.055;
["BL_Text",4,[0.045,0.145,0.45,0.04],"CREATE A CLASS"] call _make;
["BL_Text",5,[0.045,0.19,0.55,0.035],"Choose your kit. Changes apply when you next spawn."] call _make;
private _primary = ["RscCombo",200,[0.045,0.255,0.43,0.05]] call _make;
{ _primary lbAdd (_x select 0); } forEach BL_primary;
_primary lbSetCurSel (BL_editClass select 0);
_primary ctrlAddEventHandler ["LBSelChanged",{BL_editClass set [0,_this select 1];}];
private _labels = ["OPTIC","SIDEARM","FRAG GRENADE","SMOKE GRENADE"] + ["LIGHTWEIGHT","TOUGHNESS","SCAVENGER","HARDLINE"];
{
 private _index = _forEachIndex + 1;
 private _row = _forEachIndex mod 4;
 private _column = floor (_forEachIndex/4);
 private _button = ["BL_Button",200+_index,[0.045+0.245*_column,0.35+0.092*_row,0.23,0.072],format ["[%1] %2",if ((BL_editClass select _index) isEqualTo 1) then {"X"} else {" "},_x]] call _make;
 if (_index >= 5) then { _button ctrlSetTooltip (BL_perkNames select (_index-5)); };
 _button setVariable ["BL_index",_index]; _button setVariable ["BL_label",_x];
 _button ctrlAddEventHandler ["ButtonClick",{
  private _c = _this select 0; private _i = _c getVariable "BL_index";
  BL_editClass set [_i,1-(BL_editClass select _i)];
  _c ctrlSetText format ["[%1] %2",if ((BL_editClass select _i) isEqualTo 1) then {"X"} else {" "},_c getVariable "BL_label"];
  private _cost = [BL_editClass] call BL_fnc_classCost;
  ((ctrlParent _c) displayCtrl 220) ctrlSetText format ["PICK 10    %1 / 10 ALLOCATIONS",_cost];
  ((ctrlParent _c) displayCtrl 230) ctrlEnable (_cost <= 10);
 }];
} forEach _labels;
["BL_Text",220,[0.045,0.735,0.47,0.045],format ["PICK 10    %1 / 10 ALLOCATIONS",[BL_editClass] call BL_fnc_classCost]] call _make;
private _save = ["BL_Button",230,[0.045,0.815,0.225,0.065],"SAVE CLASS"] call _make;
_save ctrlAddEventHandler ["ButtonClick",{[] call BL_fnc_saveClass}];
private _close = ["BL_Button",231,[0.29,0.815,0.225,0.065],"RETURN TO MATCH"] call _make;
_close ctrlAddEventHandler ["ButtonClick",{closeDialog 0}];
private _map = ["RscMapControl",240,[0.565,0.19,0.39,0.41]] call _make;
_map ctrlMapAnimAdd [0,0.025,BL_center]; ctrlMapAnimCommit _map;
_map ctrlAddEventHandler ["Draw",{_this call BL_fnc_drawMap}];
["BL_Text",241,[0.565,0.62,0.39,0.05],"KAVALA / ALTIS"] call _make;
["BL_Text",242,[0.565,0.68,0.39,0.04],"5 UAV / 6 COUNTER UAV / 7 STRIKE"] call _make;
["BL_Text",243,[0.565,0.74,0.39,0.04],"TAB SCOREBOARD   F4 CLASS MENU"] call _make;
["BL_Text",244,[0.565,0.8,0.39,0.04],"Strike targets your crosshair (3-second delay)"] call _make;
["BL_Text",245,[0.045,0.93,0.91,0.035],"BLACK OPS II-INSPIRED ARMA MISSION  |  ORIGINAL INTERFACE  |  VANILLA ASSETS"] call _make;
