from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MISSION = ROOT / "mission" / "SQC_TDM.Stratis"

REQUIRED = [
    MISSION / "Functions/Match/fn_matchInit.sqf",
    MISSION / "Functions/Match/fn_matchHandleKill.sqf",
    MISSION / "Functions/Match/fn_matchUpdatePlayerStat.sqf",
    MISSION / "Functions/Match/fn_matchBroadcastKillFeed.sqf",
    MISSION / "Functions/Match/fn_matchEnd.sqf",
]

def fail(message: str) -> None:
    print(f"FAIL: {message}")
    raise SystemExit(1)

for path in REQUIRED:
    if not path.is_file():
        fail(f"missing {path.relative_to(ROOT)}")

description = (MISSION / "description.ext").read_text(encoding="utf-8")

for token in [
    "class Match",
    "class matchInit",
    "class matchHandleKill",
    "class matchUpdatePlayerStat",
    "class matchBroadcastKillFeed",
    "class matchEnd",
    "class TDM_WEST_WIN",
    "class TDM_EAST_WIN",
    "class TDM_DRAW",
]:
    if token not in description:
        fail(f"description.ext missing match token {token}")

if "class SQC_fnc_uiPushKillFeed" not in description:
    fail("kill-feed client function is not remote-exec whitelisted")

preinit = (MISSION / "Functions/Core/fn_preInit.sqf").read_text(encoding="utf-8")
for token in [
    '"SQC_matchScoreLimit", 75',
    '"SQC_matchTimeLimit", 600',
    '"SQC_matchRunning", false',
]:
    if token not in preinit:
        fail(f"match config missing {token}")

server = (MISSION / "Functions/Core/fn_serverInit.sqf").read_text(encoding="utf-8")
for token in [
    "SQC_fnc_matchHandleKill",
    "SQC_fnc_matchInit",
]:
    if token not in server:
        fail(f"server lifecycle missing {token}")

kill = (MISSION / "Functions/Match/fn_matchHandleKill.sqf").read_text(encoding="utf-8")
for token in [
    "SQC_matchRunning",
    "_source isEqualTo _victim",
    "_sourceSide isEqualTo _victimSide",
    'missionNamespace setVariable ["SQC_matchScores", _scores, true]',
    "SQC_fnc_matchEnd",
]:
    if token not in kill:
        fail(f"kill processing missing {token}")

timer = (MISSION / "Functions/Match/fn_matchInit.sqf").read_text(encoding="utf-8")
for token in [
    "SQC_matchEndTime",
    "serverTime",
    "SQC_matchTimeRemaining",
    '["TIME_LIMIT"] call SQC_fnc_matchEnd',
]:
    if token not in timer:
        fail(f"timer authority missing {token}")

ending = (MISSION / "Functions/Match/fn_matchEnd.sqf").read_text(encoding="utf-8")
if "BIS_fnc_endMissionServer" not in ending:
    fail("match end does not use multiplayer-safe mission ending")

print("PASS: M004 TDM match core invariants validated")
