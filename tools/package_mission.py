"""Build deterministic mission PBO/ZIP and SHA-256 checksums, without binarization."""
from pathlib import Path
import hashlib
import struct
from zipfile import ZipFile,ZipInfo,ZIP_DEFLATED
ROOT=Path(__file__).resolve().parents[1]
MISSION=ROOT/'mission/BO2_Multiplayer.Altis'
RELEASES=ROOT/'releases';RELEASES.mkdir(exist_ok=True)

def build_pbo(files):
    # Bohemia PBO: Vers properties, uncompressed entry table, terminator, file data,
    # then a zero byte plus SHA-1 of everything before the trailing signature.
    header=bytearray(b'\0'+struct.pack('<5I',0x56657273,0,0,0,0))
    header.extend(b'prefix\0BO2_Multiplayer.Altis\0\0')
    for name,data in sorted(files.items()):
        header.extend(name.replace('/','\\').encode('ascii')+b'\0')
        header.extend(struct.pack('<5I',0,0,0,0,len(data)))
    header.extend(bytes(21))
    payload=bytes(header)+b''.join(data for name,data in sorted(files.items()))
    return payload+b'\0'+hashlib.sha1(payload).digest()

if __name__=='__main__':
    files={p.relative_to(MISSION).as_posix():p.read_bytes() for p in MISSION.rglob('*') if p.is_file()}
    pbo_name='BO2_Multiplayer.Altis.pbo';pbo=build_pbo(files)
    (RELEASES/pbo_name).write_bytes(pbo)
    entries={f'{MISSION.name}/{name}':data for name,data in files.items()}
    entries[pbo_name]=pbo
    entries['README.md']=(ROOT/'README.md').read_bytes()
    entries['PLAYTEST.md']=(ROOT/'docs/PLAYTEST.md').read_bytes()
    entries['SHA256SUMS.txt']=''.join(f'{hashlib.sha256(data).hexdigest()}  {name}\n' for name,data in sorted(entries.items())).encode()
    out=RELEASES/'BLACKLINE-Multiplayer.zip'
    with ZipFile(out,'w',ZIP_DEFLATED) as archive:
        for name,data in sorted(entries.items()):
            info=ZipInfo(name,(2026,9,27,0,0,0));info.compress_type=ZIP_DEFLATED;info.external_attr=0o100644<<16
            archive.writestr(info,data)
    with ZipFile(out) as archive:
        assert archive.testzip() is None
        assert set(archive.namelist())==set(entries)
        for name,data in entries.items(): assert archive.read(name)==data,name
    (RELEASES/'SHA256SUMS.txt').write_text(''.join(f'{hashlib.sha256((RELEASES/name).read_bytes()).hexdigest()}  {name}\n' for name in [pbo_name,out.name]))
    print(f'PASS: PBO + ZIP built; {len(entries)} ZIP entries byte-verified')
