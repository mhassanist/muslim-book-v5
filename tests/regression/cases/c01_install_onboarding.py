"""INS / ONB: fresh install, cold start and the first-run flow."""

import time

from harness import strings as S
from harness.runner import test, check, Skip


@test("INS-01", "Fresh install and cold start without a crash", "install")
def fresh_install(ctx):
    d = ctx.device
    if ctx.options.get("no_install"):
        raise Skip("--no-install: using the installed app")
    check(d.unlock(), "device is locked; unlock it (or remove the PIN) and rerun")
    d.install(ctx.apk, fresh=True)
    d.grant_permissions()
    d.logcat_clear()
    d.launch(wait=15)
    check(d.top_activity().startswith(d.package),
          f"app is not in front after launch: {d.top_activity()}")
    # Release-only shrinker problems show up here (missing classes/resources)
    crashes = d.crashes()
    check(not crashes, "crash on first launch:\n" + "\n".join(crashes[:8]))
    ctx.debug = d.is_debuggable()
    ctx.note("debug build" if ctx.debug else "release build")


@test("ONB-01", "First run: location setup validates and completes to home", "onboarding")
def onboarding(ctx):
    a = ctx.app
    if a.on_home():
        raise Skip("already set up")
    seen = a.complete_onboarding(check_validation=True)
    check(seen.get("location_screen"), "location setup screen did not appear")
    check(seen.get("err_no_country", True),
          "saving without a location showed no 'choose your country' message")
    check(seen.get("err_no_method", True),
          "saving without a method showed no 'choose the method' message")
    check(seen.get("location_text"), "auto-locate did not show a location")
    ctx.note(f"location: {seen.get('location_text')}")
    check(seen.get("home"), "did not reach the home screen after onboarding")


@test("ONB-02", "Onboarding schedules the next azan (and its reminder)", "onboarding")
def alarms_after_onboarding(ctx):
    alarms = ctx.device.azan_alarms()
    check(alarms, "no azan alarm is registered after setup")
    ctx.note("alarms: " + ", ".join(alarms))


@test("INS-02", "Relaunch after a force stop re-registers the azan alarm", "install")
def force_stop_relaunch(ctx):
    d = ctx.device
    d.force_stop()
    time.sleep(2)
    # A force stop clears the app's alarms; opening the app must restore them
    d.launch(wait=15)
    d.close_ad()
    alarms = d.azan_alarms()
    check(alarms, "azan alarm missing after force stop + relaunch "
                  "(app stays 'stopped' and broadcasts are dropped)")
    ctx.note(", ".join(alarms))
