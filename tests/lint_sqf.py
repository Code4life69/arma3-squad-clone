"""Parse every mission SQF using pinned SQF-VM. This does not execute world logic."""
from pathlib import Path
import os
import subprocess
ROOT=Path(__file__).resolve().parents[1]
vm=os.environ.get('SQFVM',str(ROOT/'.tools/sqfvm'))
args=[vm,'-a','--suppress-welcome','--parse-only','--no-execute-print','--no-work-print']
# Verify that malformed code fails the parser before trusting the gate.
bad=subprocess.run(args+['--sqf','private _a = [1,2;'],text=True,capture_output=True)
assert bad.returncode or '[ERR]' in bad.stdout, 'Parser accepted malformed code'
paths=sorted((ROOT/'mission').rglob('*.sqf'))
for path in paths: args.extend(['--input-sqf',str(path)])
run=subprocess.run(args,text=True,capture_output=True,timeout=60)
if run.returncode or '[ERR]' in run.stdout:
    print(run.stdout+run.stderr)
    raise SystemExit(1)
print(f'PASS: SQF-VM parsed {len(paths)} mission scripts')
