"""PT / AZAN: prayer times screen and the native azan service."""

import re
import time

from harness import strings as S
from harness.runner import test, check, Skip


@test("PT-01", "Prayer times screen lists the six times", "prayer-times")
def six_times(ctx):
    a = ctx.app
    a.open_prayer_times()
    for key, name in S.PRAYERS.items():
        t = a.prayer_time(name)
        check(re.fullmatch(r"\d\d:\d\d", t or ""), f"{name}: no valid time ({t!r})")
    a.go_home()


@test("PT-02", "Prayer rows open the Fajr / regular muezzin pickers", "prayer-times")
def rows_open_pickers(ctx):
    a, d = ctx.app, ctx.device
    a.open_prayer_times()
    d.tap_node(a.prayer_row(S.PRAYERS["1"]), wait=4)
    check(d.wait_for(S.FAJR_PICKER_TITLE, exact=True, timeout=8), "Fajr row: Fajr picker not shown")
    d.back(wait=2.5)
    d.close_ad()
    d.tap_node(a.prayer_row(S.PRAYERS["4"]), wait=4)
    check(d.wait_for(S.PICKER_TITLE, exact=True, timeout=8), "Asr row: muezzin picker not shown")
    a.go_home()


@test("PT-03", "Share-the-app popup opens the system share sheet", "prayer-times")
def share_popup(ctx):
    a, d = ctx.app, ctx.device
    a.open_prayer_times()
    # First header icon on this screen is the share/charity popup
    _, h = d.size()
    icons = sorted([n for n in d.dump() if n.clickable and not n.label
                    and n.bounds[3] < h * 0.13], key=lambda n: n.center[0])
    for icon in icons:
        d.tap_node(icon, wait=2.5)
        if d.find(S.SHARE_APP_POPUP, exact=False):
            break
        d.back()
    check(d.find(S.SHARE_APP_POPUP, exact=False), "share-the-app popup not found")
    d.tap_label(S.SHARE_APP_BUTTON, exact=True, wait=3)
    check(not d.top_activity().startswith(d.package) or "Sharing" in "".join(d.labels())
          or d.find("Share", exact=False), "system share sheet did not open")
    d.back(force=True)    # close the system share sheet
    a.go_home()


@test("AZAN-01", "Each prayer's azan starts and plays a sound file", "azan")
def azan_each_prayer(ctx):
    d = ctx.device
    played = {}
    for key in ("1", "3", "4", "5", "6"):
        d.logcat_clear()
        d.fire_azan(key)
        time.sleep(5)
        log = dict(d.azan_log())
        check(key in log, f"azan for prayer {key} did not start (no MuslimBookAzan log)")
        played[key] = log[key]
        d.stop_azan()
    ctx.note(", ".join(f"{k}:{v}" for k, v in played.items()))


@test("AZAN-02", "When an azan starts, the next prayer is scheduled right away", "azan")
def azan_schedules_next(ctx):
    d = ctx.device
    d.fire_azan("4")
    time.sleep(5)
    alarms = d.azan_alarms()
    d.stop_azan()
    check(alarms, "no azan alarm registered while the azan was playing")
    ctx.note(", ".join(alarms))


@test("AZAN-03", "The close action stops the azan", "azan")
def azan_close(ctx):
    d = ctx.device
    d.fire_azan("5")
    time.sleep(5)
    d.stop_azan()
    time.sleep(2)
    check(not d.audio_playing(), "audio still playing after close")
