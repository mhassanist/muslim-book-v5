"""HOME / NAV / MENU: home screen, header, side menu, bottom tabs, Back."""

import re

from harness import strings as S
from harness.runner import test, check


@test("HOME-01", "Home shows the next prayer card, sections and feed tabs", "home")
def home_content(ctx):
    a, d = ctx.app, ctx.device
    a.go_home()
    labels = d.labels()
    check(any(l.startswith("صلاة ") for l in labels), "next prayer card missing")
    for tile in S.TILES:
        check(any(l == tile for l in labels), f"section tile missing: {tile}")
    for tab in (S.ISLAMIYAT, S.COMMUNITY):
        check(tab in labels, f"feed tab missing: {tab}")


@test("HOME-02", "Countdown to the next prayer is formatted HH:MM:SS", "home")
def countdown(ctx):
    ctx.app.go_home()
    label = next((l for l in ctx.device.labels() if l.startswith(S.REMAINING)), "")
    check(label, "countdown label missing")
    value = label.split(":", 1)[1].strip()
    ctx.note(value)
    check(re.fullmatch(r"\d\d:\d\d:\d\d", value),
          f"countdown is not HH:MM:SS: {value!r} (e.g. '010:02:52' when >10h remain)")


@test("NAV-01", "Each bottom tab opens its screen", "navigation")
def bottom_tabs(ctx):
    a, d = ctx.app, ctx.device
    a.go_home()
    for tab, expected in S.TABS.items():
        a.open_tab(tab)
        check(d.wait_for(expected, timeout=10), f"tab {tab}: '{expected}' not shown")
    a.go_home()


@test("NAV-02", "Back on home asks before leaving the app", "navigation")
def back_on_home(ctx):
    a, d = ctx.app, ctx.device
    a.go_home()
    d.back()
    check(d.wait_for(S.EXIT_APP_QUESTION, timeout=5), "no 'exit the app?' confirmation")
    d.back()


@test("NAV-03", "Header: settings icon opens Settings", "navigation")
def header_settings(ctx):
    ctx.app.open_settings()
    ctx.app.go_home()


@test("NAV-04", "Header: language icon offers Arabic, English and French", "navigation")
def header_language(ctx):
    a, d = ctx.app, ctx.device
    a.open_language_picker()
    labels = d.labels()
    for lang in S.LANGUAGES:
        check(lang in labels, f"language option missing: {lang}")
    d.back()


@test("MENU-01", "Side menu lists every entry", "menu")
def menu_items(ctx):
    a, d = ctx.app, ctx.device
    a.open_menu()
    labels = d.labels()
    for item in S.MENU_ITEMS:
        check(item in labels, f"menu entry missing: {item}")
    d.back()


@test("MENU-02", "Menu: top users shows both leaderboards", "menu", needs=("network",))
def menu_top_users(ctx):
    a, d = ctx.app, ctx.device
    a.open_menu()
    d.tap_label(S.TOP_USERS, wait=4)
    d.close_ad()
    for tab in S.TOP_USERS_TABS:
        check(d.wait_for(tab, timeout=10), f"leaderboard tab missing: {tab}")
    a.go_home()


@test("MENU-03", "Menu: usage policy opens the policy link outside the app", "menu")
def menu_policy(ctx):
    a, d = ctx.app, ctx.device
    a.open_menu()
    d.logcat_clear()
    d.tap_label(S.PRIVACY_POLICY, wait=5)
    log = d.logcat()
    check("android.intent.action.VIEW" in log and "docs.google.com" in log,
          "tapping the usage policy did not launch the policy URL")
    d.launch(wait=4)
    a.go_home()


@test("NAV-05", "Back with the side menu open closes the menu", "navigation")
def back_closes_menu(ctx):
    a, d = ctx.app, ctx.device
    a.open_menu()
    check(d.find(S.TOP_USERS, exact=True), "side menu did not open")
    d.back(wait=2)
    labels = d.labels()
    check(S.EXIT_APP_QUESTION not in labels,
          "Back with the menu open asked to exit the app instead of closing the menu")
    check(S.MAIN_SECTIONS in labels and S.TOP_USERS not in labels, "menu still open after Back")
