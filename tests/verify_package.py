"""Validate all PBO entries/checksums; independently mount root files with SQF-VM."""
from pathlib import Path
import hashlib
import io
import os
import struct
import subprocess
ROOT=Path(__file__).resolve().parents[1]
vm=os.environ.get('SQFVM',str(ROOT/'.tools/sqfvm'))
pbo=ROOT/'releases/BO2_Multiplayer.Altis.pbo'
data=pbo.read_bytes();stream=io.BytesIO(data)
def cstring():
    value=bytearray()
    while True:
        char=stream.read(1)
        assert char,'Truncated PBO string'
        if char==b'\0':return value.decode('ascii')
        value.extend(char)
def header():return struct.unpack('<5I',stream.read(20))
assert cstring()==''
assert header()==(0x56657273,0,0,0,0)
props={}
while True:
    key=cstring()
    if not key:break
    props[key]=cstring()
assert props['prefix']=='BO2_Multiplayer.Altis'
entries=[]
while True:
    name=cstring();method,original,reserved,timestamp,size=header()
    if not name:
        assert (method,original,reserved,timestamp,size)==(0,0,0,0,0);break
    assert method==0 and reserved==0
    entries.append((name.replace('\\','/'),size))
expected={p.relative_to(ROOT/'mission/BO2_Multiplayer.Altis').as_posix():p.read_bytes() for p in (ROOT/'mission/BO2_Multiplayer.Altis').rglob('*') if p.is_file()}
assert len(entries)==len(expected)
for name,size in entries:assert stream.read(size)==expected.pop(name),name
assert not expected
end=stream.tell()
assert stream.read(1)==b'\0'
assert stream.read(20)==hashlib.sha1(data[:end]).digest()
assert stream.read()==b''
# SQF-VM's Linux virtual filesystem does not normalize nested PBO backslashes.
# Its independent reader can still validate the two root config files exactly.
checks=[]
for name in ['mission.sqm','description.ext']:
    expected=(ROOT/'mission/BO2_Multiplayer.Altis'/name).read_text().replace('"','""')
    checks.append(f'if (!((loadFile "BO2_Multiplayer.Altis/{name}") isEqualTo "{expected}")) then {{throw "PBO config mismatch";}};')
checks.append('diag_log "BLACKLINE_PBO_VERIFIED";')
run=subprocess.run([vm,'-a','--suppress-welcome','--no-execute-print','--no-work-print','--input-pbo',str(pbo),'--sqf','\n'.join(checks)],capture_output=True,text=True,timeout=30)
if run.returncode or '[ERR]' in run.stdout or 'BLACKLINE_PBO_VERIFIED' not in run.stdout:
    print(run.stdout+run.stderr);raise SystemExit(1)
for line in (ROOT/'releases/SHA256SUMS.txt').read_text().splitlines():
    checksum,name=line.split('  ',1)
    assert hashlib.sha256((ROOT/'releases'/name).read_bytes()).hexdigest()==checksum
print('PASS: all PBO entries/checksums verified; independent SQF-VM reader loads both mission configs')
