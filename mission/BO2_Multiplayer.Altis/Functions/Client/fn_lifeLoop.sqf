if (!hasInterface) exitWith {};
while {true} do {
 if (!isNull player && {alive player}) then {
  private _applied = missionNamespace getVariable ["BL_appliedDelivery",[-1,-1]];
  private _confirmed = player getVariable ["BL_confirmedDelivery",[-1,-1]];
  private _sameLife = (missionNamespace getVariable ["BL_prepareLife",""]) isEqualTo netId player;
  BL_pending = !_sameLife || {!(player getVariable ["BL_active",false])} || {(_applied select 0) < 1} || {!(_confirmed isEqualTo _applied)};
  private _phase = (missionNamespace getVariable ["BL_state",["WARMUP"]]) select 0;
  player allowDamage (!BL_pending && {_phase isEqualTo "ACTIVE"} && {serverTime >= (player getVariable ["BL_protectedUntil",0])});
 };
 uiSleep 0.1;
};
