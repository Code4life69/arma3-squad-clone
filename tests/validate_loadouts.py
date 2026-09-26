from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MISSION = ROOT / "mission" / "SQC_TDM.Stratis"

REQUIRED = [
    MISSION / "Functions/Loadout/fn_loadoutRequestClass.sqf",
    MISSION / "Functions/Loadout/fn_loadoutApplyClass.sqf",
    MISSION / "Functions/Loadout/fn_loadoutHandleRespawn.sqf",
    MISSION / "Functions/Loadout/fn_loadoutAssignBot.sqf",
    MISSION / "Functions/Loadout/fn_loadoutDeploySelected.sqf",
]

def fail(message: str) -> None:
    print(f"FAIL: {message}")
    raise SystemExit(1)

for path in REQUIRED:
    if not path.is_file():
        fail(f"missing {path.relative_to(ROOT)}")

description = (MISSION / "description.ext").read_text(encoding="utf-8")
for token in [
    "class Loadout",
    "class loadoutRequestClass",
    "class loadoutApplyClass",
    "class loadoutHandleRespawn",
    "class loadoutAssignBot",
    "class loadoutDeploySelected",
    "class SQC_fnc_loadoutRequestClass",
    "class SQC_fnc_loadoutApplyClass",
]:
    if token not in description:
        fail(f"description missing {token}")

preinit = (MISSION / "Functions/Core/fn_preInit.sqf").read_text(encoding="utf-8")
if '"SQC_loadoutClasses", ["ASSAULT", "SMG", "LMG", "MARKSMAN", "SHOTGUN"]' not in preinit:
    fail("loadout class registry missing")

request = (MISSION / "Functions/Loadout/fn_loadoutRequestClass.sqf").read_text(encoding="utf-8")
for token in [
    "isRemoteExecuted",
    "remoteExecutedOwner",
    "owner _unit",
    "SQC_className",
    "SQC_fnc_loadoutApplyClass",
]:
    if token not in request:
        fail(f"class request validation missing {token}")

apply_class = (MISSION / "Functions/Loadout/fn_loadoutApplyClass.sqf").read_text(encoding="utf-8")
for token in [
    "isRemoteExecuted",
    "remoteExecutedOwner != 2",
    '"arifle_MX_F"',
    '"SMG_01_F"',
    '"LMG_Mk200_F"',
    '"srifle_EBR_F"',
    '"sgun_HunterShotgun_01_F"',
    '"arifle_MXC_F"',
    "isClass",
    "removeAllWeapons",
    "addMagazines",
    "addWeapon",
]:
    if token not in apply_class:
        fail(f"loadout implementation missing {token}")

server = (MISSION / "Functions/Core/fn_serverInit.sqf").read_text(encoding="utf-8")
if "SQC_fnc_loadoutHandleRespawn" not in server:
    fail("player respawn does not preserve class")

bot = (MISSION / "Functions/AI/fn_aiSpawnBot.sqf").read_text(encoding="utf-8")
if "SQC_fnc_loadoutAssignBot" not in bot:
    fail("bots do not receive class distribution")

menu = (MISSION / "UI/Menu.hpp").read_text(encoding="utf-8")
if "SQC_fnc_loadoutDeploySelected" not in menu:
    fail("DEPLOY button does not apply selected class")

print("PASS: M006 functional loadout invariants validated")
