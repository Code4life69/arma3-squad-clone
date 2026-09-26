from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
MISSION = ROOT / "mission" / "SQC_TDM.Stratis"

REQUIRED = [
    MISSION / "mission.sqm",
    MISSION / "description.ext",
    MISSION / "initServer.sqf",
    MISSION / "initPlayerLocal.sqf",
    MISSION / "onPlayerRespawn.sqf",
    MISSION / "Functions/Core/fn_preInit.sqf",
    MISSION / "Functions/Core/fn_getExecutionRole.sqf",
    MISSION / "Functions/Core/fn_log.sqf",
    MISSION / "Functions/Core/fn_serverInit.sqf",
    MISSION / "Functions/Core/fn_clientInit.sqf",
    MISSION / "Functions/Spawn/fn_buildSpawnCandidates.sqf",
    MISSION / "Functions/Spawn/fn_scoreSpawnCandidate.sqf",
    MISSION / "Functions/Spawn/fn_selectSpawnPosition.sqf",
    MISSION / "Functions/Spawn/fn_placeUnitAtSpawn.sqf",
    MISSION / "Functions/Spawn/fn_requestSpawn.sqf",
    MISSION / "Functions/Spawn/fn_applySpawn.sqf",
    MISSION / "Functions/Spawn/fn_recordDeathSpot.sqf",
]


def fail(message: str) -> None:
    print(f"FAIL: {message}")
    raise SystemExit(1)


def strip_sqf(text: str) -> str:
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.S)
    text = re.sub(r"//.*", "", text)
    text = re.sub(r'"(?:""|[^"\n])*"', '""', text)
    return text


def balanced(path: Path) -> None:
    text = strip_sqf(path.read_text(encoding="utf-8"))
    pairs = {"{": "}", "[": "]", "(": ")"}
    stack = []

    for char in text:
        if char in pairs:
            stack.append(char)
        elif char in pairs.values():
            if not stack:
                fail(f"{path.relative_to(ROOT)} unexpected closing {char}")
            opening = stack.pop()
            if pairs[opening] != char:
                fail(f"{path.relative_to(ROOT)} mismatched {opening} and {char}")

    if stack:
        fail(f"{path.relative_to(ROOT)} unclosed {stack[-1]}")


for path in REQUIRED:
    if not path.is_file():
        fail(f"missing {path.relative_to(ROOT)}")

for path in MISSION.rglob("*"):
    if path.suffix.lower() in {".sqf", ".ext", ".sqm"}:
        balanced(path)

description = (MISSION / "description.ext").read_text(encoding="utf-8")

for fn in [
    "buildSpawnCandidates",
    "scoreSpawnCandidate",
    "selectSpawnPosition",
    "placeUnitAtSpawn",
    "requestSpawn",
    "applySpawn",
    "recordDeathSpot",
]:
    if f"class {fn}" not in description:
        fail(f"CfgFunctions missing {fn}")

if 'respawnOnStart = -1;' not in description:
    fail("mission-start respawn event must be disabled to avoid duplicate initial placement")

if "class CfgRemoteExec" not in description:
    fail("CfgRemoteExec is missing")

if "class SQC_fnc_requestSpawn" not in description or "allowedTargets = 2;" not in description:
    fail("requestSpawn is not restricted to server execution")

if "class SQC_fnc_applySpawn" not in description or "allowedTargets = 1;" not in description:
    fail("applySpawn is not restricted to client targets")

preinit = (MISSION / "Functions/Core/fn_preInit.sqf").read_text(encoding="utf-8")
for token in [
    "[2915.2, 6164.52, 0]",
    '"SQC_spawnArenaRadius", 230',
    '"SQC_spawnEnemyHardMin", 18',
    '"SQC_spawnLOSRange", 120',
    '"SQC_spawnRefineCount", 24',
    '"SQC_spawnDeathMemorySeconds", 14',
    '"SQC_spawnReuseMemorySeconds", 10',
]:
    if token not in preinit:
        fail(f"spawn config missing {token}")

builder = (MISSION / "Functions/Spawn/fn_buildSpawnCandidates.sqf").read_text(encoding="utf-8")
for token in [
    "nearestTerrainObjects",
    "buildingPos -1",
    "findEmptyPosition",
    "surfaceIsWater",
    '"BUILDING"',
    '"GROUND"',
]:
    if token not in builder:
        fail(f"candidate builder missing {token}")

scorer = (MISSION / "Functions/Spawn/fn_scoreSpawnCandidate.sqf").read_text(encoding="utf-8")
for token in [
    "SQC_spawnEnemyHardMin",
    "SQC_spawnRecent",
    "SQC_spawnDeathHeat",
    "vectorDotProduct",
    "lineIntersectsSurfaces",
    "SQC_spawnLOSRange",
]:
    if token not in scorer:
        fail(f"spawn scorer missing {token}")

selector = (MISSION / "Functions/Spawn/fn_selectSpawnPosition.sqf").read_text(encoding="utf-8")
if "false] call SQC_fnc_scoreSpawnCandidate" not in selector:
    fail("selector missing coarse scoring pass")
if "true] call SQC_fnc_scoreSpawnCandidate" not in selector:
    fail("selector missing refined visibility scoring pass")
if "selectRandom _selectionPool" not in selector:
    fail("selector missing constrained finalist randomization")

request = (MISSION / "Functions/Spawn/fn_requestSpawn.sqf").read_text(encoding="utf-8")
for token in [
    "isRemoteExecuted",
    "remoteExecutedOwner",
    "owner _unit",
    'remoteExec ["SQC_fnc_requestSpawn", 2]',
    "SQC_initialSpawnDone",
]:
    if token not in request:
        fail(f"initial spawn request validation missing {token}")

server = (MISSION / "Functions/Core/fn_serverInit.sqf").read_text(encoding="utf-8")
for token in [
    '"EntityKilled"',
    '"EntityRespawned"',
    "SQC_fnc_placeUnitAtSpawn",
    "!isPlayer _x",
]:
    if token not in server:
        fail(f"server respawn authority missing {token}")

respawn = (MISSION / "onPlayerRespawn.sqf").read_text(encoding="utf-8")
if "SQC_fnc_requestSpawn" in respawn:
    fail("onPlayerRespawn must not independently request a second placement")

all_spawn_sqf = "\n".join(
    p.read_text(encoding="utf-8")
    for p in (MISSION / "Functions/Spawn").rglob("*.sqf")
)

if "allowDamage false" in all_spawn_sqf:
    fail("M001 must not hide bad spawns behind default invulnerability")

sqm = (MISSION / "mission.sqm").read_text(encoding="utf-8")
for token in ['"A3_Map_Stratis"', 'name="respawn_west"', 'name="respawn_east"']:
    if token not in sqm:
        fail(f"Stratis mission missing {token}")

print("PASS: M001 dynamic spawn director invariants validated")
