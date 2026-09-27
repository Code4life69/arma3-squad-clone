if (!hasInterface || {isNil "BL_editClass"} || {[BL_editClass] call BL_fnc_classCost > 10}) exitWith {};
BL_class = +BL_editClass;
[player,"class",+BL_class] remoteExecCall ["BL_fnc_request",2];
closeDialog 0;
