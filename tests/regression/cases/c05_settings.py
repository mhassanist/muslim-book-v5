"""SET: every Settings section."""

import re
import time

from harness import strings as S
from harness.runner import test, check, Skip


@test("SET-01", "Settings lists all seven sections and the app version", "settings")
def sections_and_version(ctx):
    a, d = ctx.app, ctx.device
    a.open_settings()
    labels = d.labels()
    for sec in S.SECTIONS:
        check(sec in labels, f"section missing: {sec}")
    for _ in range(3):
        version = next((l for l in d.labels() if l.startswith(S.VERSION_PREFIX)), "")
        if version:
            break
        d.swipe_up(0.5)
    name, code = d.installed_version()
    ctx.note(version)
    check(version, "version line missing at the end of Settings")
    check(f"{name} ({code})" in version,
          f"version line {version!r} does not match the installed {name} ({code})")
    a.go_home()


@test("SET-02", "Notification switches toggle and restore", "settings")
def notification_switches(ctx):
    a, d = ctx.app, ctx.device
    a.open_settings()
    a.toggle_section(S.SEC_NOTIFICATIONS)
    switches = a.switches()
    check(len(switches) >= 4, f"expected 4 switches, found {len(switches)}")
    for i in range(len(switches)):
        before = a.switches()[i]
        d.tap_node(before, wait=2)
        flipped = a.switches()[i]
        check(flipped.checked != before.checked, f"switch {i + 1} did not toggle")
        d.tap_node(flipped, wait=2)
        check(a.switches()[i].checked == before.checked, f"switch {i + 1} did not restore")
    a.go_home()


@test("SET-03", "Country: auto-locate shows the detected place", "settings")
def country_autolocate(ctx):
    a, d = ctx.app, ctx.device
    a.open_settings()
    a.toggle_section(S.SEC_COUNTRY)
    d.tap_label(S.AUTO_LOCATE, wait=8)
    place = next((l for l in d.labels() if " - " in l), "")
    ctx.note(place)
    check(place, "no location shown after auto-locate")
    a.go_home()


def _set_madhab(ctx, label):
    a, d = ctx.app, ctx.device
    a.open_settings()
    a.toggle_section(S.SEC_METHOD)
    current = next((n for n in d.dump() if n.label in (S.HANAFI, S.SHAFII)), None)
    check(current, "madhab dropdown not found")
    if current.label != label:
        d.tap_node(current, wait=2)
        d.tap_label(label, exact=True, wait=2)
    d.tap_label(S.SAVE_SETTINGS, wait=10)
    d.close_ad()


@test("SET-04", "Changing the madhab updates Asr immediately and moves the azan",
      "settings", needs=("network",))
def madhab_updates_times(ctx):
    a = ctx.app
    a.open_prayer_times()
    shafii_asr = a.prayer_time(S.PRAYERS["4"])
    _set_madhab(ctx, S.HANAFI)
    a.open_prayer_times()
    hanafi_asr = a.prayer_time(S.PRAYERS["4"])
    ctx.note(f"Asr {shafii_asr} -> {hanafi_asr}")
    _set_madhab(ctx, S.SHAFII)
    a.open_prayer_times()
    restored = a.prayer_time(S.PRAYERS["4"])
    check(hanafi_asr > shafii_asr,
          f"Asr did not move later with Hanafi ({shafii_asr} -> {hanafi_asr}) "
          "without restarting the app")
    check(restored == shafii_asr, f"Asr did not return to {shafii_asr} (shows {restored})")
    a.go_home()


@test("SET-05", "Prayer time correction: +2 min on Asr is saved and shown", "settings")
def time_correction(ctx):
    a, d = ctx.app, ctx.device
    a.open_prayer_times()
    before = a.prayer_time(S.PRAYERS["4"])
    a.open_settings()
    a.toggle_section(S.SEC_CORRECTION)
    buttons = d.find_all(S.SEC_CORRECTION, exact=True)
    check(len(buttons) >= 2, "correction section has no button to open the editor")
    d.tap_node(buttons[-1], wait=4)
    d.close_ad()

    def plus_minus(sign):
        row = d.find(S.CORRECTION_ROW.format(S.PRAYERS["4"]), exact=False)
        check(row, "Asr correction row not found")
        y = row.center[1]
        btns = sorted([n for n in d.dump() if n.clickable and not n.label
                       and row.bounds[1] <= n.center[1] <= row.bounds[3]],
                      key=lambda n: n.center[0])
        check(len(btns) >= 2, "Asr +/- buttons not found")
        # In the Arabic layout '+' is the leftmost, '-' the next one
        d.tap_node(btns[0] if sign > 0 else btns[1], wait=1.5)
        return d.find(S.CORRECTION_ROW.format(S.PRAYERS["4"]), exact=False)

    plus_minus(+1)
    row = plus_minus(+1)
    check(row and row.lines[-1] == "2", f"correction did not count up to 2: {row and row.label!r}")
    d.tap_label(S.SAVE, exact=True, wait=8)       # app-bar save, returns to Settings
    d.close_ad()
    check(d.find(S.SETTINGS, exact=True), "saving the editor did not return to Settings")
    if ctx.debug:
        check(d.prefs().get("update4") == "2", "Asr correction not saved")
    a.open_prayer_times()
    after = a.prayer_time(S.PRAYERS["4"])
    ctx.note(f"Asr {before} -> {after}")
    h, m = map(int, before.split(":"))
    check(after == f"{h:02d}:{m + 2:02d}" or after > before,
          f"Asr shows {after}, expected 2 minutes after {before}")

    # restore
    a.open_settings()
    a.toggle_section(S.SEC_CORRECTION)
    d.tap_node(d.find_all(S.SEC_CORRECTION, exact=True)[-1], wait=4)
    d.close_ad()
    plus_minus(-1)
    plus_minus(-1)
    d.tap_label(S.SAVE, exact=True, wait=8)
    d.close_ad()
    a.go_home()


@test("SET-06", "Correction editor shows all six prayers", "settings")
def correction_rows(ctx):
    a, d = ctx.app, ctx.device
    a.open_settings()
    a.toggle_section(S.SEC_CORRECTION)
    d.tap_node(d.find_all(S.SEC_CORRECTION, exact=True)[-1], wait=4)
    d.close_ad()
    for key, name in S.PRAYERS.items():
        row = d.find(S.CORRECTION_ROW.format(name), exact=False)
        check(row and row.visible, f"correction row for {name} not visible")
    a.go_home()
