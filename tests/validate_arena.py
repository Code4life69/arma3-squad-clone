"""Integration contracts that can be checked without an Arma executable."""
from pathlib import Path
import re
import runpy
ROOT=Path(__file__).resolve().parents[1]
M=ROOT/'mission/BO2_Multiplayer.Altis'
# Keep the original runtime's regression gate intact.
base=runpy.run_path(str(ROOT/'tests/validate_structure.py'))
for path in M.rglob('*'):
    if path.suffix in {'.sqf','.ext','.sqm'}: base['assert_balanced'](path)
cfg=(M/'description.ext').read_text()
functions={p.stem[3:]:p for p in M.rglob('fn_*.sqf')}
for name,path in functions.items():
    assert re.search(r'\bclass '+name+r'\s*\{',cfg),f'Unregistered: {path}'
all_code='\n'.join(p.read_text() for p in M.rglob('*.sqf'))
for name in set(re.findall(r'\bBL_fnc_(\w+)\b',all_code)):
    assert name in functions,f'Missing function: {name}'
remotes=set(re.findall(r'remoteExecCall\s*\["(\w+)"',all_code))
assert remotes=={'BL_fnc_request','BL_fnc_receive','BL_fnc_event'},remotes
for name in remotes: assert 'class '+name in cfg
assert 'class Commands { mode=0; jip=0; };' in cfg
request=functions['request'].read_text()
for required in ['owner _unit != remoteExecutedOwner','!isPlayer _unit','count _data != 9','BL_fnc_classCost > 10','BL_active']:
    assert required in request,required
for name in ['receive','event']:
    assert 'remoteExecutedOwner != 2' in functions[name].read_text()
for name in ['serverInit','serverLoop','resetMatch','publish','bots','deploy','killed','objectives','streak','buildSpawns','selectSpawn']:
    assert '!isServer' in functions[name].read_text(),name
spawn=functions['selectSpawn'].read_text()
for required in ['_nearEnemy > _minimumEnemyDistance','checkVisibility','_occupied','_reserved','BL_deathHeat','BL_spawnScan','exitWith {[]}']:
    assert required in spawn,required
assert 'setPosATL' in functions['receive'].read_text()
assert 'setPosATL' in functions['deploy'].read_text()
assert 'getPosATL' in functions['killed'].read_text()
for name in ['RscText','RscStructuredText','RscButton','RscMapControl']:
    assert f'import {name};' in cfg
sqm=(M/'mission.sqm').read_text()
assert sqm.count('isPlayable=1;')==32
assert sqm.count('isPlayer=1;')==1
assert 'A3_Map_Altis' in sqm
assert len(re.findall(r'\bid=\d+;',sqm))==len(set(re.findall(r'\bid=(\d+);',sqm)))
print(f'PASS: arena registration, 32 slots, network boundaries, and spawn contracts ({len(functions)} functions)')
