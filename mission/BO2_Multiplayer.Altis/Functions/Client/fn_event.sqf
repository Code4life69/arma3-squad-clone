params ["_type","_data"];
if (!hasInterface || {!isRemoteExecuted} || {remoteExecutedOwner != 2}) exitWith {};
switch _type do {
 case "notice": { BL_notice = [_data select 0,diag_tickTime + 4]; };
 case "award": { BL_notice = [format ["+%1  %2",_data select 0,_data select 1],diag_tickTime + 2]; };
 case "kill": {
  BL_feed pushBack [_data,diag_tickTime + 6];
  if (count BL_feed > 5) then { BL_feed deleteAt 0; };
 };
};
