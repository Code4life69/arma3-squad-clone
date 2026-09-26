from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MISSION = ROOT / "mission" / "SQC_TDM.Stratis"

REQUIRED = [
    MISSION / "Functions/Combat/fn_combatInitLocal.sqf",
    MISSION / "Functions/Combat/fn_combatApplyUnit.sqf",
    MISSION / "Functions/Combat/fn_combatHandleDamage.sqf",
]

def fail(message: str) -> None:
    print(f"FAIL: {message}")
    raise SystemExit(1)

for path in REQUIRED:
    if not path.is_file():
        fail(f"missing {path.relative_to(ROOT)}")

description = (MISSION / "description.ext").read_text(encoding="utf-8")
for token in [
    "class Combat",
    "class combatInitLocal",
    "class combatApplyUnit",
    "class combatHandleDamage",
]:
    if token not in description:
        fail(f"CfgFunctions missing {token}")

preinit = (MISSION / "Functions/Core/fn_preInit.sqf").read_text(encoding="utf-8")
for token in [
    '"SQC_friendlyFire", false',
    '"SQC_damageScale", 0.86',
    '"SQC_healthRegenDelay", 5',
    '"SQC_playerAimCoef", 0.55',
    '"SQC_playerRecoilCoef", 0.75',
    '"SQC_combatLocalInitialized", false',
]:
    if token not in preinit:
        fail(f"combat config missing {token}")

apply_unit = (MISSION / "Functions/Combat/fn_combatApplyUnit.sqf").read_text(encoding="utf-8")
for token in [
    "local _unit",
    "enableStamina false",
    "setCustomAimCoef",
    "setUnitRecoilCoefficient",
    '"HandleDamage"',
    "SQC_combatConfigured",
]:
    if token not in apply_unit:
        fail(f"combat unit configuration missing {token}")

handler = (MISSION / "Functions/Combat/fn_combatHandleDamage.sqf").read_text(encoding="utf-8")
for token in [
    "_currentDamage",
    "SQC_friendlyFire",
    "SQC_lastDamageTime",
    "SQC_damageScale",
    "_proposedDamage - _currentDamage",
]:
    if token not in handler:
        fail(f"damage handler missing {token}")

local_loop = (MISSION / "Functions/Combat/fn_combatInitLocal.sqf").read_text(encoding="utf-8")
for token in [
    "SQC_combatLocalInitialized",
    "forEach allUnits",
    "local _x",
    "SQC_healthRegenDelay",
    "setDamage 0",
    "sleep 0.25",
]:
    if token not in local_loop:
        fail(f"regen loop missing {token}")

client = (MISSION / "Functions/Core/fn_clientInit.sqf").read_text(encoding="utf-8")
for token in ["SQC_fnc_combatInitLocal", "SQC_fnc_combatApplyUnit"]:
    if token not in client:
        fail(f"client lifecycle missing {token}")

server = (MISSION / "Functions/Core/fn_serverInit.sqf").read_text(encoding="utf-8")
if "SQC_fnc_combatInitLocal" not in server:
    fail("server does not initialize local combat loop for server-owned AI")

bot = (MISSION / "Functions/AI/fn_aiSpawnBot.sqf").read_text(encoding="utf-8")
if "SQC_fnc_combatApplyUnit" not in bot:
    fail("new bots are not configured for arcade combat")

respawn = (MISSION / "onPlayerRespawn.sqf").read_text(encoding="utf-8")
if "SQC_fnc_combatApplyUnit" not in respawn:
    fail("respawned human unit is not reconfigured for arcade combat")

if "allowDamage false" in "\n".join(p.read_text(encoding="utf-8") for p in REQUIRED):
    fail("combat pace must not add spawn invulnerability")

print("PASS: M005 arcade combat pace invariants validated")
