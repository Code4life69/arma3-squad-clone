from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
MISSION = ROOT / "mission" / "SQC_TDM.Stratis"

REQUIRED = [
    MISSION / "UI/BaseControls.hpp",
    MISSION / "UI/HUD.hpp",
    MISSION / "UI/Menu.hpp",
    MISSION / "Functions/UI/fn_uiInit.sqf",
    MISSION / "Functions/UI/fn_uiUpdateHud.sqf",
    MISSION / "Functions/UI/fn_uiMapDraw.sqf",
    MISSION / "Functions/UI/fn_uiOpenMenu.sqf",
    MISSION / "Functions/UI/fn_uiSelectClass.sqf",
    MISSION / "Functions/UI/fn_uiRefreshMenu.sqf",
    MISSION / "Functions/UI/fn_uiPushKillFeed.sqf",
]

def fail(message: str) -> None:
    print(f"FAIL: {message}")
    raise SystemExit(1)

for path in REQUIRED:
    if not path.is_file():
        fail(f"missing {path.relative_to(ROOT)}")

description = (MISSION / "description.ext").read_text(encoding="utf-8")

for token in [
    '#include "UI\\BaseControls.hpp"',
    '#include "UI\\Menu.hpp"',
    "class RscTitles",
    '#include "UI\\HUD.hpp"',
    "class UI",
    "class uiInit",
    "class uiUpdateHud",
    "class uiMapDraw",
    "class uiOpenMenu",
    "class uiSelectClass",
    "class uiRefreshMenu",
    "class uiPushKillFeed",
]:
    if token not in description:
        fail(f"description.ext missing UI integration token: {token}")

hud = (MISSION / "UI/HUD.hpp").read_text(encoding="utf-8")
for token in [
    "class Minimap : RscMapControl",
    "idc = 7703;",
    "idc = 7722;",
    "idc = 7725;",
    "idc = 7726;",
    "idc = 7730;",
    "idc = 7744;",
    "idc = 7746;",
    "safeZoneX",
    "safeZoneY",
    "safeZoneW",
    "safeZoneH",
]:
    if token not in hud:
        fail(f"HUD missing BO2-style layout token: {token}")

menu = (MISSION / "UI/Menu.hpp").read_text(encoding="utf-8")
for token in [
    'text = "MULTIPLAYER";',
    'text = "TEAM DEATHMATCH  //  AGIA MARINA";',
    'text = "CREATE A CLASS";',
    'text = "DEPLOY";',
    "idc = 7810;",
    "idc = 7814;",
    "idc = 7833;",
    "safeZoneX",
    "safeZoneH",
]:
    if token not in menu:
        fail(f"menu missing expected visual-shell token: {token}")

client = (MISSION / "Functions/Core/fn_clientInit.sqf").read_text(encoding="utf-8")
if "SQC_fnc_uiInit" not in client:
    fail("client init does not start UI")
if "SQC_fnc_uiOpenMenu" not in client:
    fail("client init does not expose the initial multiplayer menu")

updater = (MISSION / "Functions/UI/fn_uiUpdateHud.sqf").read_text(encoding="utf-8")
for token in [
    "SQC_matchScores",
    "SQC_matchTimeRemaining",
    "magazinesAmmoFull",
    "currentWeaponMode",
    "ctrlMapAnimAdd",
    "SQC_killFeed",
]:
    if token not in updater:
        fail(f"HUD updater missing {token}")

map_draw = (MISSION / "Functions/UI/fn_uiMapDraw.sqf").read_text(encoding="utf-8")
if "drawIcon" not in map_draw:
    fail("minimap does not draw local/team icons")
if "allUnits" not in map_draw:
    fail("minimap does not inspect current friendlies")

for path in [MISSION / "UI/HUD.hpp", MISSION / "UI/Menu.hpp"]:
    text = path.read_text(encoding="utf-8")
    if "a3\\ui_f" in text.lower() or "callofduty" in text.lower() or "blackops" in text.lower():
        fail(f"{path.name} contains copied/external asset path references")

print("PASS: M002 BO2-style visual shell invariants validated")
