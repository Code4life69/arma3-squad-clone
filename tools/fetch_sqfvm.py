"""Install the pinned Linux x64 SQF-VM test runtime, verifying its release checksum."""
from pathlib import Path
import hashlib
import io
import urllib.request
import zipfile
ROOT=Path(__file__).resolve().parents[1]
URL='https://github.com/SQFvm/runtime/releases/download/v2026.04.03-ed9f5f5/sqfvm_linux_x64_gcc.zip'
SHA='bb4e3bb415305d2ef2c4cdb75e98f442baea3a4575887c6570a11435a780615b'
with urllib.request.urlopen(URL,timeout=60) as response: data=response.read()
if hashlib.sha256(data).hexdigest()!=SHA: raise SystemExit('SQF-VM checksum mismatch')
with zipfile.ZipFile(io.BytesIO(data)) as archive:
    binary=archive.read('sqfvm_linux_x64_gcc/sqfvm')
path=ROOT/'.tools/sqfvm'; path.parent.mkdir(exist_ok=True); path.write_bytes(binary); path.chmod(0o755)
print('Installed verified SQF-VM release v2026.04.03-ed9f5f5')
