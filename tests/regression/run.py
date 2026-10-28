#!/usr/bin/env python3
"""Muslim Book regression suite.

    python3 tests/regression/run.py --apk build/app/outputs/flutter-apk/app-release.apk

See tests/regression/README.md.
"""

import argparse
import datetime
import importlib
import os
import pkgutil
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

from harness.app import App                      # noqa: E402
from harness.device import Device                # noqa: E402
from harness.runner import TESTS, Context, run, write_reports  # noqa: E402


def pick_device(serial):
    if serial:
        return serial
    lines = subprocess.run(["adb", "devices"], capture_output=True, text=True).stdout
    devices = [l.split()[0] for l in lines.splitlines()[1:] if l.strip().endswith("device")]
    if len(devices) != 1:
        sys.exit(f"Pass --device; connected devices: {devices or 'none'}")
    return devices[0]


def _read_account(path):
    if not path:
        return None
    with open(path) as f:
        cfg = dict(l.strip().split("=", 1) for l in f if "=" in l)
    if not cfg.get("email") or not cfg.get("password"):
        sys.exit(f"{path}: needs email=... and password=... lines")
    return cfg


def main():
    p = argparse.ArgumentParser(description=__doc__,
                                formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("--apk", help="APK under test (release build recommended)")
    p.add_argument("--device", help="adb serial (default: the only connected device)")
    p.add_argument("--package", default="com.muslim_book.muslim_book")
    p.add_argument("--no-install", action="store_true",
                   help="test the app already installed (no fresh install/onboarding)")
    p.add_argument("--only", help="comma-separated test IDs or groups, e.g. MZ,SET-04,azan")
    p.add_argument("--skip", help="comma-separated test IDs or groups to skip")
    p.add_argument("--offline", action="store_true", help="skip tests that need the internet")
    p.add_argument("--monkey", type=int, default=3000, help="stress events (0 to skip)")
    p.add_argument("--min-version-code", type=int,
                   help="last released versionCode; the APK must be higher")
    p.add_argument("--allow-debug-signing", action="store_true",
                   help="don't fail REL-04 for debug-signed APKs")
    p.add_argument("--account", help="file with email=... and password=... of a test "
                   "account for the logged-in tests (keep it out of the repo)")
    p.add_argument("--google-account", help="Google account on the device to test "
                   "Google sign-in with (its email)")
    p.add_argument("--allow-posts", action="store_true",
                   help="let LOGIN-05 publish a test post to the live feed")
    p.add_argument("--list", action="store_true", help="list the tests and exit")
    p.add_argument("--out", help="report directory (default tests/regression/out/<time>)")
    args = p.parse_args()

    for _, name, _ in pkgutil.iter_modules([os.path.join(HERE, "cases")]):
        importlib.import_module(f"cases.{name}")

    def matches(t, spec):
        keys = {s.strip().lower() for s in spec.split(",") if s.strip()}
        return t["id"].lower() in keys or t["group"].lower() in keys or \
            t["id"].split("-")[0].lower() in keys

    selected = [t for t in TESTS
                if (not args.only or matches(t, args.only))
                and not (args.skip and matches(t, args.skip))]
    if args.list:
        for t in TESTS:
            needs = f" [{', '.join(sorted(t['needs']))}]" if t["needs"] else ""
            print(f"{t['id']:10} {t['group']:13} {t['title']}{needs}")
        return 0
    if not args.apk and not args.no_install:
        p.error("--apk is required (or --no-install to test the installed app)")
    if args.apk and not os.path.exists(args.apk):
        p.error(f"APK not found: {args.apk}")
    if args.no_install:
        selected = [t for t in selected if t["group"] != "release" or args.apk]

    serial = pick_device(args.device)
    device = Device(serial, args.package)
    stamp = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
    out = args.out or os.path.join(HERE, "out", stamp)
    ctx = Context(device=device, app=App(device), apk=os.path.abspath(args.apk) if args.apk else "",
                  out_dir=out, debug=args.no_install and device.is_debuggable(),
                  network=not args.offline,
                  options=dict(monkey_events=args.monkey, no_install=args.no_install,
                               min_version_code=args.min_version_code,
                               allow_debug=args.allow_debug_signing,
                               account=_read_account(args.account),
                               google_account=args.google_account,
                               allow_posts=args.allow_posts))

    print(f"Device {serial} (Android SDK {device.sdk()}), {len(selected)} tests -> {out}")
    results = run(ctx, selected)
    name, code = device.installed_version()
    counts = write_reports(results, out, {
        "Date": stamp, "Device": f"{serial} (SDK {device.sdk()})",
        "APK": args.apk or "(installed)", "App version": f"{name} ({code})",
        "Build type": "debug" if ctx.debug else "release",
    })
    print(f"\n{counts['pass']} passed, {counts['fail']} failed, {counts['error']} errors, "
          f"{counts['skip']} skipped. Report: {os.path.join(out, 'report.md')}")
    return 1 if counts["fail"] or counts["error"] else 0


if __name__ == "__main__":
    sys.exit(main())
