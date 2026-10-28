"""MZ: choosing the muezzin in Settings and per prayer, and what actually plays.

The azan service logs the file it plays ("MuslimBookAzan: key=4
file=azan_3.mp3"): built-in sheikhs are azan_<0-4>.mp3, downloaded ones
azan_sound<id>.mp3, the Fajr default azan_mshary_fajr.mp3.
"""

import time

from harness import strings as S
from harness.runner import test, check, Skip

MUSTAFA, AQSA = S.BUILTIN_SHEIKHS[3], S.BUILTIN_SHEIKHS[4]


def _played(ctx, key):
    d = ctx.device
    d.logcat_clear()
    d.fire_azan(key)
    time.sleep(5)
    files = dict(d.azan_log())
    d.stop_azan()
    check(key in files, f"azan for prayer {key} did not start")
    return files[key]


def _open_settings_picker(ctx, section):
    a, d = ctx.app, ctx.device
    a.open_settings()
    a.toggle_section(section)
    buttons = d.find_all(S.PICKER_TITLE, exact=True)
    check(buttons, f"{section}: choose button not found")
    d.tap_node(buttons[0], wait=4)
    d.close_ad()


def _open_prayer_picker(ctx, key):
    a, d = ctx.app, ctx.device
    a.open_prayer_times()
    d.tap_node(a.prayer_row(S.PRAYERS[key]), wait=5)
    d.close_ad()


def _pick(ctx, label):
    d = ctx.device
    node = d.wait_for(label, exact=True, timeout=10)
    if not node:
        ctx.app.picker_load_more()
        node = d.wait_for(label, exact=True, timeout=15)
    check(node, f"muezzin not in the list: {label}")
    d.tap_node(node, wait=3)


@test("MZ-01", "Settings shows the muezzin the azan will play", "muezzin")
def settings_shows_current(ctx):
    a = ctx.app
    a.open_settings()
    a.toggle_section(S.SEC_SHEIKH)
    name = a.section_value(S.SEC_SHEIKH)
    a.toggle_section(S.SEC_SHEIKH)
    a.toggle_section(S.SEC_FAJR_SHEIKH)
    fajr = a.section_value(S.SEC_FAJR_SHEIKH)
    ctx.note(f"all prayers: {name}; Fajr: {fajr}")
    check(name and name != S.PICKER_TITLE, "Azan muezzin section shows no name")
    check(fajr and fajr != S.PICKER_TITLE, "Fajr muezzin section shows no name")
    a.go_home()


@test("MZ-02", "Choosing a muezzin in Settings applies to every prayer", "muezzin")
def settings_applies_to_all(ctx):
    a = ctx.app
    _open_settings_picker(ctx, S.SEC_SHEIKH)
    if not ctx.device.find(MUSTAFA, exact=True):
        raise Skip("built-in list not shown (muezzins were downloaded before)")
    _pick(ctx, MUSTAFA)
    a.picker_save()
    check(a.section_value(S.SEC_SHEIKH) == MUSTAFA,
          f"Settings section shows {a.section_value(S.SEC_SHEIKH)!r}, expected {MUSTAFA}")
    if ctx.debug:
        p = ctx.device.prefs()
        for k in "23456":
            check(p.get(f"AZAN_SHIEKH_LOCAL_ID{k}") == "3",
                  f"prayer {k} not saved as Mustafa (got {p.get(f'AZAN_SHIEKH_LOCAL_ID{k}')})")
    for key in ("4", "5"):
        f = _played(ctx, key)
        check(f == "azan_3.mp3", f"prayer {key} played {f}, expected azan_3.mp3 (Mustafa)")


@test("MZ-03", "The prayer-times picker shows the choice made in Settings", "muezzin")
def prayer_picker_matches(ctx):
    _open_prayer_picker(ctx, "4")
    selected = ctx.app.picker_selected()
    ctx.note(f"selected: {selected}")
    check(selected == MUSTAFA, f"Asr picker highlights {selected!r}, expected {MUSTAFA}")
    ctx.app.go_home()


@test("MZ-04", "Changing one prayer's muezzin leaves the others alone", "muezzin")
def one_prayer_only(ctx):
    _open_prayer_picker(ctx, "4")
    if not ctx.device.find(AQSA, exact=True):
        raise Skip("built-in list not shown")
    _pick(ctx, AQSA)
    ctx.app.picker_save()
    check(_played(ctx, "4") == "azan_4.mp3", "Asr did not switch to Al-Aqsa (azan_4)")
    check(_played(ctx, "5") == "azan_3.mp3", "Maghrib changed too; expected Mustafa (azan_3)")
    _open_prayer_picker(ctx, "4")
    check(ctx.app.picker_selected() == AQSA, "Asr picker does not highlight Al-Aqsa")
    ctx.app.go_home()


@test("MZ-05", "A downloaded muezzin chosen in Settings plays for all prayers", "muezzin",
      needs=("network",))
def downloaded_for_all(ctx):
    a, d = ctx.app, ctx.device
    _open_settings_picker(ctx, S.SEC_SHEIKH)
    a.picker_load_more()
    rows = [n for n in d.dump() if n.label.startswith(("أذان", "اذان"))]
    check(len(rows) >= 2, "online muezzin list did not load")
    choice = rows[1].label
    d.tap_node(rows[1], wait=12)         # downloads, then previews
    a.picker_save()
    check(a.section_value(S.SEC_SHEIKH) == choice,
          f"Settings shows {a.section_value(S.SEC_SHEIKH)!r}, expected {choice!r}")
    files = {k: _played(ctx, k) for k in ("4", "5")}
    ctx.note(f"{choice}: {files}")
    check(all(f.startswith("azan_sound") for f in files.values()),
          f"prayers did not switch to the downloaded file: {files}")
    check(files["4"] == files["5"], f"prayers play different files: {files}")
    ctx.options["downloaded_choice"] = choice


@test("MZ-06", "Prayer-times picker highlights the downloaded choice", "muezzin",
      needs=("network",))
def downloaded_highlight(ctx):
    choice = ctx.options.get("downloaded_choice")
    if not choice:
        raise Skip("MZ-05 did not run")
    _open_prayer_picker(ctx, "5")
    check(ctx.app.picker_selected() == choice,
          f"Maghrib picker highlights {ctx.app.picker_selected()!r}, expected {choice!r}")
    ctx.app.go_home()


@test("MZ-07", "Fajr: default plays, and a choice from Settings plays and is shown",
      "muezzin", needs=("network",))
def fajr_choice(ctx):
    a, d = ctx.app, ctx.device
    before = _played(ctx, "1")
    ctx.note(f"before: {before}")
    _open_settings_picker(ctx, S.SEC_FAJR_SHEIKH)
    a.picker_load_more()
    rows = [n for n in d.dump() if n.label.startswith(("أذان", "اذان", "الشيخ"))]
    check(rows, "online Fajr list did not load")
    choice = rows[-1].label
    d.tap_node(rows[-1], wait=12)
    a.picker_save()
    check(a.section_value(S.SEC_FAJR_SHEIKH) == choice,
          f"Fajr section shows {a.section_value(S.SEC_FAJR_SHEIKH)!r}, expected {choice!r}")
    after = _played(ctx, "1")
    ctx.note(f"{choice}: {after}")
    check(after.startswith("azan_sound") and after != before,
          f"Fajr still plays {after}")
    _open_prayer_picker(ctx, "1")
    check(a.picker_selected() == choice, "Fajr picker does not highlight the new choice")
    a.go_home()


@test("MZ-08", "Previews: rapid taps leave only the last one playing", "muezzin")
def preview_rapid_taps(ctx):
    a, d = ctx.app, ctx.device
    _open_prayer_picker(ctx, "3")
    rows = [n for n in d.dump() if n.label in S.BUILTIN_SHEIKHS or
            n.label.startswith(("أذان", "اذان"))][:4]
    check(len(rows) >= 2, "no muezzin rows to preview")
    for r in rows:
        d.shell(f"input tap {r.center[0]} {r.center[1]}")
    time.sleep(3)
    selected = a.picker_selected()
    check(selected == rows[-1].label,
          f"after rapid taps {selected!r} is selected, expected {rows[-1].label!r}")
    # Audio can't be confirmed on every device (see README); report, don't fail
    ctx.note("audio playing" if d.audio_playing() else "audio not detected (check by ear)")
    d.back(wait=2)
    a.go_home()
