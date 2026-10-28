"""Minimal test runner: registry, per-test isolation, reports."""

import html
import os
import time
import traceback
from dataclasses import dataclass, field

from .app import App
from .device import Device

TESTS = []


class Skip(Exception):
    pass


class Failure(AssertionError):
    pass


def test(test_id, title, group, needs=()):
    """Registers a test. `needs`: 'debug' (reads app data), 'network'."""
    def wrap(fn):
        TESTS.append(dict(id=test_id, title=title, group=group, needs=set(needs), fn=fn))
        return fn
    return wrap


def check(cond, message):
    if not cond:
        raise Failure(message)


@dataclass
class Context:
    device: Device
    app: App
    apk: str
    out_dir: str
    debug: bool
    network: bool
    options: dict
    notes: list = field(default_factory=list)

    def note(self, msg):
        self.notes.append(msg)


@dataclass
class Result:
    id: str
    title: str
    group: str
    status: str          # pass | fail | skip | error
    seconds: float
    message: str = ""
    notes: list = field(default_factory=list)
    screenshot: str = ""


def run(ctx: Context, selected: list, log=print) -> list:
    results = []
    for t in selected:
        if "debug" in t["needs"] and not ctx.debug:
            results.append(Result(t["id"], t["title"], t["group"], "skip", 0,
                                  "needs a debug build"))
            log(f"  SKIP {t['id']} {t['title']} (needs a debug build)")
            continue
        if "network" in t["needs"] and not ctx.network:
            results.append(Result(t["id"], t["title"], t["group"], "skip", 0, "offline run"))
            continue
        other = ctx.device.foreign_app()
        if other and t["group"] not in ("release", "install"):
            msg = f"run stopped: {other} is in front (is someone using the phone?)"
            log(f"  STOP  {msg}")
            for rest in selected[selected.index(t):]:
                results.append(Result(rest["id"], rest["title"], rest["group"], "error", 0, msg))
            break
        ctx.notes = []
        start = time.time()
        ctx.device.logcat_clear()
        status, message, shot = "pass", "", ""
        try:
            t["fn"](ctx)
            crashes = ctx.device.crashes()
            if crashes:
                status, message = "fail", "app crash/error in log:\n" + "\n".join(crashes[:8])
        except Skip as e:
            status, message = "skip", str(e)
        except Failure as e:
            status, message = "fail", str(e)
        except Exception as e:  # harness/device problems
            status, message = "error", f"{type(e).__name__}: {e}\n{traceback.format_exc(limit=3)}"
        if status in ("fail", "error"):
            shot = os.path.join(ctx.out_dir, "screens", f"{t['id']}.png")
            try:
                ctx.device.screenshot(shot)
                with open(os.path.join(ctx.out_dir, "screens", f"{t['id']}.log"), "w") as f:
                    f.write(ctx.device.logcat()[-20000:])
            except Exception:
                shot = ""
        r = Result(t["id"], t["title"], t["group"], status, time.time() - start,
                   message, list(ctx.notes), shot)
        results.append(r)
        log(f"  {status.upper():5} {t['id']} {t['title']} ({r.seconds:.0f}s)"
            + (f"\n        {message.splitlines()[0]}" if message and status != "pass" else ""))
    return results


def write_reports(results: list, out_dir: str, meta: dict):
    os.makedirs(out_dir, exist_ok=True)
    counts = {s: sum(r.status == s for r in results) for s in ("pass", "fail", "error", "skip")}
    lines = [f"# Regression report", "",
             *[f"- **{k}**: {v}" for k, v in meta.items()], "",
             f"**{counts['pass']} passed, {counts['fail']} failed, "
             f"{counts['error']} errors, {counts['skip']} skipped**", "",
             "| ID | Test | Result | Time | Details |", "|---|---|---|---|---|"]
    icon = {"pass": "✅", "fail": "❌", "error": "⚠️", "skip": "⏭"}
    for r in results:
        detail = (r.message.splitlines()[0] if r.message else "") + \
            (" — " + "; ".join(r.notes) if r.notes else "")
        if r.screenshot:
            detail += f" ([screen]({os.path.relpath(r.screenshot, out_dir)}))"
        lines.append(f"| {r.id} | {r.title} | {icon[r.status]} {r.status} | "
                     f"{r.seconds:.0f}s | {detail.replace('|', '/')} |")
    with open(os.path.join(out_dir, "report.md"), "w") as f:
        f.write("\n".join(lines) + "\n")

    cases = []
    for r in results:
        body = ""
        if r.status == "fail":
            body = f'<failure message="{html.escape(r.message[:200])}">{html.escape(r.message)}</failure>'
        elif r.status == "error":
            body = f'<error message="{html.escape(r.message[:200])}">{html.escape(r.message)}</error>'
        elif r.status == "skip":
            body = f'<skipped message="{html.escape(r.message)}"/>'
        cases.append(f'<testcase classname="{r.group}" name="{r.id} {html.escape(r.title)}" '
                     f'time="{r.seconds:.1f}">{body}</testcase>')
    with open(os.path.join(out_dir, "junit.xml"), "w") as f:
        f.write(f'<?xml version="1.0" encoding="UTF-8"?>\n<testsuite name="muslim-book-regression" '
                f'tests="{len(results)}" failures="{counts["fail"]}" errors="{counts["error"]}" '
                f'skipped="{counts["skip"]}">\n' + "\n".join(cases) + "\n</testsuite>\n")
    return counts
