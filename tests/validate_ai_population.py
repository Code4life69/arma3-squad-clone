from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MISSION = ROOT / "mission" / "SQC_TDM.Stratis"

REQUIRED = [
    MISSION / "Functions/AI/fn_aiInit.sqf",
    MISSION / "Functions/AI/fn_aiReconcile.sqf",
    MISSION / "Functions/AI/fn_aiSpawnBot.sqf",
    MISSION / "Functions/AI/fn_aiRetireBot.sqf",
    MISSION / "Functions/AI/fn_aiHandleKilled.sqf",
]

def fail(message: str) -> None:
    print(f"FAIL: {message}")
    raise SystemExit(1)

for path in REQUIRED:
    if not path.is_file():
        fail(f"missing {path.relative_to(ROOT)}")

description = (MISSION / "description.ext").read_text(encoding="utf-8")

if "disabledAI = 1;" not in description:
    fail("unoccupied playable slots must not create unmanaged vanilla AI")

for token in [
    "class AI",
    "class aiInit",
    "class aiReconcile",
    "class aiSpawnBot",
    "class aiRetireBot",
    "class aiHandleKilled",
]:
    if token not in description:
        fail(f"CfgFunctions missing {token}")

preinit = (MISSION / "Functions/Core/fn_preInit.sqf").read_text(encoding="utf-8")
for token in [
    '"SQC_aiTeamSize", 6',
    '"SQC_aiRespawnDelay", 2',
    '"SQC_aiCorpseCleanupDelay", 10',
    '"SQC_nextBotId", 1',
]:
    if token not in preinit:
        fail(f"AI config missing {token}")

server = (MISSION / "Functions/Core/fn_serverInit.sqf").read_text(encoding="utf-8")
for token in [
    "SQC_fnc_aiInit",
    "SQC_fnc_aiHandleKilled",
]:
    if token not in server:
        fail(f"server lifecycle missing {token}")

reconcile = (MISSION / "Functions/AI/fn_aiReconcile.sqf").read_text(encoding="utf-8")
for token in [
    "allPlayers",
    "allUnits",
    "SQC_managedBot",
    "SQC_fnc_aiSpawnBot",
    "SQC_fnc_aiRetireBot",
]:
    if token not in reconcile:
        fail(f"reconcile missing {token}")

spawn = (MISSION / "Functions/AI/fn_aiSpawnBot.sqf").read_text(encoding="utf-8")
for token in [
    "createGroup",
    "createUnit",
    "SQC_managedBot",
    "SQC_fnc_placeUnitAtSpawn",
    "setSkill",
]:
    if token not in spawn:
        fail(f"bot spawn missing {token}")

# The only long-running AI population loop belongs in aiInit.
for path in REQUIRED[1:]:
    text = path.read_text(encoding="utf-8")
    if "while {" in text:
        fail(f"per-function permanent loop forbidden in {path.name}")

print("PASS: M003 AI population invariants validated")
