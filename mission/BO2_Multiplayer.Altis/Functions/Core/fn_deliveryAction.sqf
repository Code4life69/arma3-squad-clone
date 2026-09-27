// 0 = reject stale/inconsistent delivery; 1 = ACK only; 2 = apply then ACK.
params ["_appliedId","_appliedRound","_incomingId","_incomingRound"];
if (_incomingId <= 0 || {_incomingId < _appliedId}) exitWith {0};
if (_incomingId isEqualTo _appliedId) exitWith {
 if (_incomingRound isEqualTo _appliedRound) then {1} else {0}
};
2
