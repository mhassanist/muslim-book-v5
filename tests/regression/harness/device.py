"""Drives an Android device over adb: screen reading, taps, logs, alarms.

Screens are read with `uiautomator dump`, which exposes Flutter's semantics
(text and content-desc). Everything is located by label, never by fixed
coordinates, because the layout shifts with insets, ads and languages.
"""

import os
import re
import subprocess
import time
import xml.etree.ElementTree as ET
from dataclasses import dataclass


class DeviceError(Exception):
    pass


@dataclass
class Node:
    text: str
    desc: str
    cls: str
    bounds: tuple  # (x1, y1, x2, y2)
    clickable: bool
    checkable: bool
    checked: bool
    selected: bool

    @property
    def label(self) -> str:
        return self.text or self.desc

    @property
    def lines(self) -> list:
        return [l.strip() for l in self.label.split("\n") if l.strip()]

    @property
    def center(self) -> tuple:
        x1, y1, x2, y2 = self.bounds
        return (x1 + x2) // 2, (y1 + y2) // 2

    @property
    def visible(self) -> bool:
        x1, y1, x2, y2 = self.bounds
        return x2 > x1 and y2 > y1

    def __repr__(self):
        return f"Node({self.label[:40]!r} @ {self.center})"


AD_ACTIVITY = "com.google.android.gms.ads.AdActivity"


class Device:
    def __init__(self, serial: str, package: str, log=print):
        self.serial = serial
        self.package = package
        self.log = log
        self._size = None

    # ---- adb -------------------------------------------------------------

    def adb(self, *args, timeout=60, check=False) -> str:
        cmd = ["adb", "-s", self.serial, *args]
        try:
            res = subprocess.run(cmd, capture_output=True, timeout=timeout)
        except subprocess.TimeoutExpired:
            raise DeviceError(f"adb timed out: {' '.join(args)}")
        out = res.stdout.decode("utf-8", "replace")
        if check and res.returncode != 0:
            raise DeviceError(f"adb failed ({res.returncode}): {' '.join(args)}\n"
                              f"{res.stderr.decode('utf-8', 'replace')}")
        return out

    def shell(self, cmd: str, timeout=60) -> str:
        return self.adb("shell", cmd, timeout=timeout)

    def sdk(self) -> int:
        return int(self.shell("getprop ro.build.version.sdk").strip() or 0)

    def size(self) -> tuple:
        if not self._size:
            m = re.search(r"(\d+)x(\d+)", self.shell("wm size").splitlines()[-1])
            self._size = (int(m[1]), int(m[2]))
        return self._size

    def pid(self) -> str:
        return self.shell(f"pidof {self.package}").strip()

    def is_debuggable(self) -> bool:
        out = self.shell(f"run-as {self.package} id 2>&1")
        return "uid=" in out

    def installed_version(self) -> tuple:
        out = self.shell(f"dumpsys package {self.package}")
        code = re.search(r"versionCode=(\d+)", out)
        name = re.search(r"versionName=(\S+)", out)
        return (name[1] if name else None, int(code[1]) if code else None)

    # ---- app lifecycle ---------------------------------------------------

    def install(self, apk: str, fresh=True):
        if fresh:
            self.adb("uninstall", self.package)
        out = self.adb("install", "-r", apk, timeout=300)
        if "Success" not in out:
            raise DeviceError(f"install failed: {out.strip()}")

    def grant_permissions(self):
        for perm in ("ACCESS_FINE_LOCATION", "ACCESS_COARSE_LOCATION",
                     "POST_NOTIFICATIONS"):
            self.shell(f"pm grant {self.package} android.permission.{perm} 2>/dev/null")
        self.shell(f"appops set {self.package} SYSTEM_ALERT_WINDOW allow")

    def launch(self, wait=12):
        self.shell(f"monkey -p {self.package} -c android.intent.category.LAUNCHER 1")
        time.sleep(wait)

    def force_stop(self):
        self.shell(f"am force-stop {self.package}")

    def unlock(self):
        self.shell("input keyevent KEYCODE_WAKEUP")
        if "isKeyguardShowing=true" in self.shell("dumpsys window"):
            w, h = self.size()
            self.shell(f"input swipe {w // 2} {int(h * .8)} {w // 2} {int(h * .3)} 300")
            time.sleep(1)
        return "isKeyguardShowing=true" not in self.shell("dumpsys window")

    def top_activity(self) -> str:
        out = self.shell("dumpsys activity activities")
        # Android 12+: "topResumedActivity=ActivityRecord{..}";
        # Android 11: "mResumedActivity: ActivityRecord{..}"
        m = re.search(r"topResumedActivity=.*? (\S+/\S+)", out) or \
            re.search(r"mResumedActivity[=:] ?.*? (\S+/\S+)", out)
        return m[1].rstrip("}") if m else ""

    def app_in_front(self) -> bool:
        top = self.top_activity()
        return top.startswith(self.package) and AD_ACTIVITY not in top

    # ---- screen ----------------------------------------------------------

    def dump(self, retries=3) -> list:
        for _ in range(retries):
            raw = self.adb("exec-out", "uiautomator", "dump", "/dev/tty", timeout=40)
            end = raw.rfind("</hierarchy>")
            start = raw.find("<?xml")
            if start != -1 and end != -1:
                try:
                    root = ET.fromstring(raw[start:end + len("</hierarchy>")])
                except ET.ParseError:
                    time.sleep(1)
                    continue
                nodes = []
                for n in root.iter("node"):
                    b = re.findall(r"\d+", n.get("bounds", "[0,0][0,0]"))
                    nodes.append(Node(
                        text=n.get("text", ""), desc=n.get("content-desc", ""),
                        cls=n.get("class", ""), bounds=tuple(map(int, b)),
                        clickable=n.get("clickable") == "true",
                        checkable=n.get("checkable") == "true",
                        checked=n.get("checked") == "true",
                        selected=n.get("selected") == "true"))
                return nodes
            time.sleep(1)  # usually "could not get idle state" while animating
        return []

    def labels(self) -> list:
        return [n.label for n in self.dump() if n.label]

    def find(self, label: str, exact=True, nodes=None, visible=True):
        """First node whose label (or one of its lines) matches."""
        for n in nodes if nodes is not None else self.dump():
            if visible and not n.visible:
                continue
            if exact and (n.label == label or label in n.lines):
                return n
            if not exact and label in n.label:
                return n
        return None

    def find_all(self, label: str, exact=False, nodes=None) -> list:
        nodes = nodes if nodes is not None else self.dump()
        return [n for n in nodes if n.visible and (
            (exact and (n.label == label or label in n.lines)) or
            (not exact and label in n.label))]

    def wait_for(self, label: str, timeout=15, exact=False):
        end = time.time() + timeout
        while time.time() < end:
            n = self.find(label, exact=exact)
            if n:
                return n
            time.sleep(1)
        return None

    def wait_gone(self, label: str, timeout=10, exact=False) -> bool:
        end = time.time() + timeout
        while time.time() < end:
            if not self.find(label, exact=exact):
                return True
            time.sleep(1)
        return False

    def screenshot(self, path: str):
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "wb") as f:
            f.write(subprocess.run(["adb", "-s", self.serial, "exec-out",
                                    "screencap", "-p"], capture_output=True,
                                   timeout=30).stdout)

    # ---- input -----------------------------------------------------------

    def tap(self, x: int, y: int, wait=2.0):
        # Never tap while an ad is showing: it would count as an ad click
        if not self.app_in_front():
            self.close_ad()
            if not self.app_in_front():
                raise DeviceError(f"refusing to tap, app not in front: {self.top_activity()}")
        self.shell(f"input tap {x} {y}")
        time.sleep(wait)

    def tap_node(self, node: Node, wait=2.0):
        self.tap(*node.center, wait=wait)

    def tap_label(self, label: str, exact=True, timeout=10, wait=2.0):
        node = self.wait_for(label, timeout=timeout, exact=exact) if timeout else \
            self.find(label, exact=exact)
        if not node:
            raise DeviceError(f"label not found: {label!r}")
        self.tap_node(node, wait=wait)
        return node

    def foreign_app(self) -> str:
        """The foreground package when it is neither this app nor an ad,
        e.g. someone using the phone; '' otherwise."""
        top = self.top_activity()
        if not top or top.startswith(self.package) or AD_ACTIVITY in top:
            return ""
        return top

    def _guard(self, action):
        other = self.foreign_app()
        if other:
            raise DeviceError(f"refusing to {action}: {other} is in front "
                              "(is someone using the phone?)")

    def back(self, wait=1.5, force=False):
        """force=True only when a test itself opened another app (share
        sheet, browser) and is backing out of it."""
        if not force:
            self._guard("press Back")
        self.shell("input keyevent BACK")
        time.sleep(wait)

    def swipe_up(self, fraction=0.5, wait=1.5):
        self._guard("swipe")
        w, h = self.size()
        y1, y2 = int(h * 0.75), int(h * (0.75 - fraction))
        self.shell(f"input swipe {w // 2} {y1} {w // 2} {y2} 400")
        time.sleep(wait)

    def type_text(self, text: str):
        self.shell(f"input text {text}")
        time.sleep(0.5)

    # ---- ads -------------------------------------------------------------

    def close_ad(self, attempts=6):
        """Close an interstitial via its close button or Back after the
        countdown; never taps the ad itself."""
        for _ in range(attempts):
            if AD_ACTIVITY not in self.top_activity():
                return True
            closer = None
            for n in self.dump():
                d = (n.desc or "").lower()
                if n.clickable and ("close" in d or "skip" in d or "إغلاق" in d):
                    closer = n
                    break
            if closer:
                self.shell(f"input tap {closer.center[0]} {closer.center[1]}")
            else:
                time.sleep(4)
                self.shell("input keyevent BACK")
            time.sleep(2)
        return AD_ACTIVITY not in self.top_activity()

    # ---- logs ------------------------------------------------------------

    def logcat_clear(self):
        self.adb("logcat", "-c")

    def logcat(self, args=("-d",)) -> str:
        return self.adb("logcat", *args, timeout=60)

    def crashes(self) -> list:
        """App crashes, ANRs and uncaught Flutter errors since the last clear."""
        lines = []
        for l in self.logcat().splitlines():
            if ("FATAL EXCEPTION" in l or "AndroidRuntime: Process:" in l
                    or ("ANR in" in l and self.package in l)
                    or " E flutter" in l
                    or "Unhandled Exception" in l
                    or "component is not present" in l):
                lines.append(l.strip())
        return lines

    def azan_log(self) -> list:
        """(key, file) pairs logged by the azan service since the last clear."""
        return re.findall(r"MuslimBookAzan: key=(\d+) file=(\S+)", self.logcat())

    # ---- alarms / azan ---------------------------------------------------

    def azan_alarms(self) -> list:
        """Pending azan alarm times, 'YYYY-MM-DD HH:MM'."""
        out = self.shell("dumpsys alarm")
        times = set()
        blocks = out.split("tag=*walarm*:")
        for b in blocks[1:]:
            if not b.startswith(f"{self.package}/.receivers.azan.AzanReceiver"):
                continue
            m = re.search(r"(?:origWhen=| when=)(\d{4}-\d\d-\d\d \d\d:\d\d)", b[:600])
            if m:
                times.add(m[1])
        return sorted(times)

    def fire_azan(self, key: str):
        """Start the azan for a prayer exactly as its alarm does."""
        self.shell(f"am broadcast -n {self.package}/.receivers.azan.AzanReceiver "
                   f"--ez open_azan true --es nextAzanKEY {key}")

    def stop_azan(self):
        self.shell(f"am broadcast -n {self.package}/.receivers.azan.AzanReceiver "
                   f"--ez close_azan true")
        time.sleep(1.5)

    def audio_playing(self) -> bool:
        pid = self.pid()
        if not pid:
            return False
        out = self.shell("dumpsys audio")
        return any(f"/{pid} " in l and "state:started" in l
                   for l in out.splitlines() if "AudioPlaybackConfiguration" in l)

    # ---- app data (debug builds only) ------------------------------------

    def prefs(self) -> dict:
        """The app's FlutterSharedPreferences, or {} when not debuggable."""
        raw = self.shell(f"run-as {self.package} cat "
                         f"shared_prefs/FlutterSharedPreferences.xml 2>/dev/null")
        if "<map" not in raw:
            return {}
        out = {}
        root = ET.fromstring(raw[raw.find("<map"):raw.rfind("</map>") + 6])
        for el in root:
            name = el.get("name", "")
            if name.startswith("flutter."):
                name = name[len("flutter."):]
            out[name] = el.get("value") if el.get("value") is not None else (el.text or "")
        return out
