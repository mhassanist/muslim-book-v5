"""REL: checks on the APK itself, before it touches a device."""

import glob
import os
import re
import subprocess
import tempfile
import zipfile

from harness.runner import test, check, Skip

SDK = os.environ.get("ANDROID_HOME") or os.path.expanduser("~/Library/Android/sdk")


def _tool(pattern):
    found = sorted(glob.glob(os.path.join(SDK, pattern)))
    return found[-1] if found else None


def _badging(apk):
    aapt2 = _tool("build-tools/*/aapt2")
    if not aapt2:
        raise Skip("aapt2 not found (set ANDROID_HOME)")
    return subprocess.run([aapt2, "dump", "badging", apk], capture_output=True,
                          text=True).stdout


@test("REL-01", "APK version name/code are set and the code is above the old per-ABI codes",
      "release")
def version_code(ctx):
    out = _badging(ctx.apk)
    code = int(re.search(r"versionCode='(\d+)'", out)[1])
    name = re.search(r"versionName='([^']+)'", out)[1]
    ctx.note(f"{name} ({code})")
    # Old per-ABI APKs used 1023-4023; anything lower can't update those users
    check(code > 4023, f"versionCode {code} must be above 4023")
    min_code = ctx.options.get("min_version_code")
    if min_code:
        check(code > int(min_code), f"versionCode {code} must be above the last "
                                    f"released code {min_code}")


@test("REL-02", "Targets Android 16 (API 36) and supports Android 7+", "release")
def sdk_levels(ctx):
    out = _badging(ctx.apk)
    target = int(re.search(r"targetSdkVersion:'(\d+)'", out)[1])
    min_sdk = int(re.search(r"minSdkVersion:'(\d+)'", out)[1])
    ctx.note(f"min {min_sdk}, target {target}")
    check(target >= 36, f"Play requires target API 36, APK targets {target}")
    check(min_sdk <= 24, f"minSdk {min_sdk} drops more devices than before (24)")


@test("REL-03", "Native libraries are 16 KB page aligned", "release")
def page_size(ctx):
    zipalign = _tool("build-tools/*/zipalign")
    readelf = _tool("ndk/*/toolchains/llvm/prebuilt/*/bin/llvm-readelf")
    if not zipalign or not readelf:
        raise Skip("zipalign / NDK llvm-readelf not found")
    res = subprocess.run([zipalign, "-c", "-P", "16", "4", ctx.apk], capture_output=True,
                         text=True)
    check(res.returncode == 0, "zip entries are not 16 KB aligned:\n" + res.stdout[-500:])
    bad = []
    with tempfile.TemporaryDirectory() as tmp, zipfile.ZipFile(ctx.apk) as z:
        for name in z.namelist():
            if name.startswith("lib/arm64-v8a/") and name.endswith(".so"):
                path = z.extract(name, tmp)
                hdr = subprocess.run([readelf, "-lW", path], capture_output=True,
                                     text=True).stdout
                aligns = [int(a, 16) for a in re.findall(r"LOAD\s.*\s(0x[0-9a-f]+)$", hdr, re.M)]
                if aligns and min(aligns) < 0x4000:
                    bad.append(f"{os.path.basename(name)} ({hex(min(aligns))})")
    check(not bad, "libraries not aligned to 16 KB: " + ", ".join(bad))


@test("REL-04", "Signed with the release (upload) key, not the debug key", "release")
def signing(ctx):
    apksigner = _tool("build-tools/*/apksigner")
    if not apksigner:
        raise Skip("apksigner not found")
    out = subprocess.run([apksigner, "verify", "--print-certs", ctx.apk],
                         capture_output=True, text=True).stdout
    dn = re.search(r"Signer #1 certificate DN: (.+)", out)
    check(dn, "APK is not signed")
    ctx.note(dn[1])
    if ctx.options.get("allow_debug"):
        return
    check("Android Debug" not in dn[1], "APK is signed with the debug key")
