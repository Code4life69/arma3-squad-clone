"""Build a deterministic, directly extractable mission source ZIP."""
from pathlib import Path
from zipfile import ZipFile,ZipInfo,ZIP_DEFLATED
ROOT=Path(__file__).resolve().parents[1]
MISSION=ROOT/'mission/BO2_Multiplayer.Altis'
out=ROOT/'releases/BLACKLINE-Multiplayer.zip';out.parent.mkdir(exist_ok=True)
entries={str(p.relative_to(MISSION.parent)):p.read_bytes() for p in MISSION.rglob('*') if p.is_file()}
entries['README.md']=(ROOT/'README.md').read_bytes()
entries['PLAYTEST.md']=(ROOT/'docs/PLAYTEST.md').read_bytes()
with ZipFile(out,'w',ZIP_DEFLATED) as archive:
    for name,data in sorted(entries.items()):
        info=ZipInfo(name,(2026,9,26,0,0,0));info.compress_type=ZIP_DEFLATED;info.external_attr=0o100644<<16
        archive.writestr(info,data)
with ZipFile(out) as archive:
    assert archive.testzip() is None
    assert set(archive.namelist())==set(entries)
    for name,data in entries.items(): assert archive.read(name)==data,name
print(f'PASS: packaged and byte-verified {len(entries)} files: {out.relative_to(ROOT)}')
