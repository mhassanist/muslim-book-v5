"""STRESS: random input across the whole app; runs last."""

import re

from harness.runner import test, check, Skip


@test("STRESS-01", "Random taps/swipes/Back across the app: no crash or ANR", "stress")
def monkey(ctx):
    d = ctx.device
    events = int(ctx.options.get("monkey_events", 3000))
    if events <= 0:
        raise Skip("--monkey 0")
    d.logcat_clear()
    out = d.shell(f"monkey -p {d.package} --throttle 200 --pct-syskeys 0 "
                  f"--pct-appswitch 2 --ignore-security-exceptions -s 4242 -v {events}",
                  timeout=events // 2 + 600)
    injected = re.search(r"Events injected: (\d+)", out)
    ctx.note(f"{injected[1] if injected else '?'} events")
    check("// CRASH" not in out and "// NOT RESPONDING" not in out,
          "monkey hit a crash/ANR:\n" + "\n".join(
              l for l in out.splitlines() if "CRASH" in l or "NOT RESPONDING" in l)[:800])
    check(injected and int(injected[1]) >= events * 0.9, "monkey aborted early:\n" + out[-400:])
    ctx.app.go_home()
