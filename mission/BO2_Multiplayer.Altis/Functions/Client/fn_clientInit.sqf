if (!hasInterface) exitWith {};
waitUntil {sleep 0.1; !isNull player && {!isNil "BL_state"} && {!isNull findDisplay 46}};
enableSentences false;
enableRadio false;
showHUD [true,false,false,false,false,false,false,false,false,false,false];
[] spawn BL_fnc_prepare;
("BL_HUD" call BIS_fnc_rscLayer) cutRsc ["BL_HUD","PLAIN"];
[] spawn BL_fnc_hud;
(findDisplay 46) displayAddEventHandler ["KeyDown",{
 params ["_display","_key","_shift","_ctrl","_alt"];
 private _handled = false;
 if (_key isEqualTo 62) then { [] call BL_fnc_menu; _handled = true; };
 if (_key isEqualTo 15) then { BL_boardHeld = true; _handled = true; };
 if (_key in [6,7,8] && {!BL_pending}) then {
  private _choice = [6,7,8] find _key;
  private _data = [_choice];
  if (_choice isEqualTo 2) then { _data pushBack (screenToWorld [0.5,0.5]); };
  [player,"streak",_data] remoteExecCall ["BL_fnc_request",2];
  _handled = true;
 };
 _handled
}];
(findDisplay 46) displayAddEventHandler ["KeyUp",{ if ((_this select 1) isEqualTo 15) then { BL_boardHeld = false; }; false }];
addMissionEventHandler ["Draw3D",{
 if (isNil "BL_state") exitWith {};
 private _mode = BL_state select 1;
 if (_mode in [1,2]) then {
  {
   if (_mode isEqualTo 1 || {_forEachIndex isEqualTo (BL_state select 6)}) then {
    private _color = [[0.85,0.85,0.85,0.8],[0.25,0.75,1,0.8],[1,0.35,0.1,0.8]] select ((_x select 2)+1);
    drawIcon3D ["\a3\ui_f\data\map\markers\military\objective_CA.paa",_color,(_x select 1) vectorAdd [0,0,3],0.8,0.8,0,_x select 0,1,0.035,"RobotoCondensed"];
   };
  } forEach (BL_state select 5);
 };
 if (_mode isEqualTo 3) then {
  { drawIcon3D ["\a3\ui_f\data\map\markers\military\pickup_CA.paa",[1,0.6,0.1,0.9],(_x select 0) vectorAdd [0,0,0.8],0.6,0.6,0,"TAG",1,0.025,"RobotoCondensed"]; } forEach (BL_state select 11);
 };
}];
[] call BL_fnc_menu;
