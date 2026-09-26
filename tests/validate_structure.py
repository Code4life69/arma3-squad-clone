from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
MISSION = ROOT / "mission" / "SQC_SquadClone.VR"

REQUIRED = [
    MISSION / "mission.sqm",
    MISSION / "description.ext",
    MISSION / "initServer.sqf",
    MISSION / "initPlayerLocal.sqf",
    MISSION / "Functions/Core/fn_preInit.sqf",
    MISSION / "Functions/Core/fn_getExecutionRole.sqf",
    MISSION / "Functions/Core/fn_log.sqf",
    MISSION / "Functions/Core/fn_assert.sqf",
    MISSION / "Functions/Core/fn_serverInit.sqf",
    MISSION / "Functions/Core/fn_clientInit.sqf",
    MISSION / "Functions/Core/fn_headlessInit.sqf",
]

FUNCTIONS = {
    "preInit": "Functions/Core/fn_preInit.sqf",
    "getExecutionRole": "Functions/Core/fn_getExecutionRole.sqf",
    "log": "Functions/Core/fn_log.sqf",
    "assert": "Functions/Core/fn_assert.sqf",
    "serverInit": "Functions/Core/fn_serverInit.sqf",
    "clientInit": "Functions/Core/fn_clientInit.sqf",
    "headlessInit": "Functions/Core/fn_headlessInit.sqf",
}


def fail(message: str) -> None:
    print(f"FAIL: {message}")
    raise SystemExit(1)


def sanitized(text: str) -> str:
    # Consume strings before comments so UI text containing // stays a string.
    pattern = r'"(?:""|[^"\n])*"|/\*.*?\*/|//[^\n]*'
    text = re.sub(pattern, lambda m: '""' if m.group().startswith('"') else '', text, flags=re.S)
    return text


def assert_balanced(path: Path) -> None:
    text = sanitized(path.read_text(encoding="utf-8"))
    pairs = {"{": "}", "[": "]", "(": ")"}
    stack = []
    for char in text:
        if char in pairs:
            stack.append(char)
        elif char in pairs.values():
            if not stack:
                fail(f"{path.relative_to(ROOT)} has an unexpected closing {char}")
            opening = stack.pop()
            if pairs[opening] != char:
                fail(f"{path.relative_to(ROOT)} has mismatched {opening} ... {char}")
    if stack:
        fail(f"{path.relative_to(ROOT)} has an unclosed delimiter {stack[-1]}")


for path in REQUIRED:
    if not path.is_file():
        fail(f"missing required file: {path.relative_to(ROOT)}")

for path in MISSION.rglob("*"):
    if path.suffix.lower() in {".sqf", ".ext", ".sqm"}:
        assert_balanced(path)

description = (MISSION / "description.ext").read_text(encoding="utf-8")
for name, relative in FUNCTIONS.items():
    if f"class {name}" not in description:
        fail(f"CfgFunctions does not register {name}")
    if not (MISSION / relative).is_file():
        fail(f"registered function {name} has no file")

if "preInit = 1;" not in description:
    fail("core preInit function is not marked preInit")

server_init = (MISSION / "initServer.sqf").read_text(encoding="utf-8")
if "SQC_fnc_serverInit" not in server_init:
    fail("initServer.sqf does not enter SQC_fnc_serverInit")

player_init = (MISSION / "initPlayerLocal.sqf").read_text(encoding="utf-8")
for token in ("hasInterface", "SQC_fnc_clientInit", "SQC_fnc_headlessInit", "!isServer"):
    if token not in player_init:
        fail(f"initPlayerLocal.sqf is missing role boundary: {token}")

role_fn = (MISSION / "Functions/Core/fn_getExecutionRole.sqf").read_text(encoding="utf-8")
for role in ("HOST_SERVER", "DEDICATED_SERVER", "PLAYER_CLIENT", "HEADLESS_CLIENT"):
    if role not in role_fn:
        fail(f"execution role function is missing {role}")

server_fn = (MISSION / "Functions/Core/fn_serverInit.sqf").read_text(encoding="utf-8")
if "if (!isServer) exitWith" not in server_fn:
    fail("serverInit lacks a server locality guard")

client_fn = (MISSION / "Functions/Core/fn_clientInit.sqf").read_text(encoding="utf-8")
if "if (!hasInterface) exitWith" not in client_fn:
    fail("clientInit lacks an interface guard")

hc_fn = (MISSION / "Functions/Core/fn_headlessInit.sqf").read_text(encoding="utf-8")
if "if (isServer || hasInterface) exitWith" not in hc_fn:
    fail("headlessInit lacks a headless-only guard")

all_sqf = "\n".join(path.read_text(encoding="utf-8") for path in MISSION.rglob("*.sqf"))
if re.search(r"\bremoteExec(?:Call)?\b", all_sqf):
    fail("M001 must not introduce remote execution before the network whitelist milestone")

sqm = (MISSION / "mission.sqm").read_text(encoding="utf-8")
for token in ('type="B_Soldier_SL_F"', "isPlayer=1;", "isPlayable=1;", '"A3_Map_VR"'):
    if token not in sqm:
        fail(f"VR mission is missing expected bootstrap token: {token}")

print("PASS: M001 structure and bootstrap invariants validated")
