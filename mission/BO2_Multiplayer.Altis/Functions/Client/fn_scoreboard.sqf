params ["_state"];
private _text = "<t size='1.5' color='#ef7027'>BLACKLINE // MATCH REPORT</t><br/><t color='#9aa3aa'>PLAYER                                      K / D       SCORE</t><br/>";
{
 private _team = _forEachIndex;
 _text = _text + format ["<br/><t color='%1'>%2</t><br/>",["#59bde8","#ed7a42"] select _team,_x];
 private _ranked = [];
 { if ((_x select 1) isEqualTo _team) then { _ranked pushBack [_x select 5,_forEachIndex]; }; } forEach (_state select 8);
 _ranked sort false;
 {
  private _r = (_state select 8) select (_x select 1);
  private _name = toString ((toArray (_r select 2)) apply {if (_x in [38,60,62]) then {32} else {_x}});
  _text = _text + format ["%1 <t align='right'>%2 / %3       %4</t><br/>",_name,_r select 3,_r select 4,_r select 5];
 } forEach (_ranked select [0,6]);
} forEach ["BLACK OPS","MERCENARIES"];
_text
