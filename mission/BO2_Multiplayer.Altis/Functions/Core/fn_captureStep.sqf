// Pure Domination rule, shared with executable regression tests.
params ["_owner","_meter","_west","_east"];
private _contested = _west > 0 && {_east > 0};
private _captured = false;
if (!_contested && {_west + _east > 0}) then {
 private _direction = if (_west > 0) then {1} else {-1};
 _meter = -10 max (10 min (_meter + _direction * ((_west + _east) min 3)));
 if ((_owner isEqualTo 0 && {_meter <= 0}) || {_owner isEqualTo 1 && {_meter >= 0}}) then { _owner = -1; };
 if (abs _meter >= 10) then {
  private _newOwner = if (_meter > 0) then {0} else {1};
  _captured = _owner != _newOwner;
  _owner = _newOwner;
 };
};
[_owner,_meter,_contested,_captured]
