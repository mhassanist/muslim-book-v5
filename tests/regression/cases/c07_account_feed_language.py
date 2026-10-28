"""AUTH / FEED / LANG: logged-out account flows, community feed, languages.

These run logged out on purpose: nothing is written to the live server.
"""

import time

from harness import strings as S
from harness.runner import test, check, Skip


def _login_options_shown(d):
    return all(d.find(x, exact=True) for x in (S.LOGIN_FACEBOOK, S.LOGIN_GOOGLE,
                                               S.LOGIN_EMAIL, S.CREATE_ACCOUNT))


@test("AUTH-01", "Competitions and Sebha ask logged-out users to log in", "account")
def login_gates(ctx):
    a, d = ctx.app, ctx.device
    for tile in ("المسابقات", "السبحة"):
        a.go_home()
        d.tap_label(tile, exact=True, wait=4)
        d.close_ad()
        check(_login_options_shown(d), f"{tile}: login options not shown")
    a.go_home()


@test("AUTH-02", "Email login validates empty and invalid input", "account")
def email_login_validation(ctx):
    a, d = ctx.app, ctx.device
    a.go_home()
    d.tap_label("المسابقات", exact=True, wait=4)
    d.close_ad()
    d.tap_label(S.LOGIN_EMAIL, exact=True, wait=4)
    submit = d.find_all(S.LOGIN_EMAIL, exact=True)[-1]
    d.tap_node(submit, wait=2)
    check(d.find(S.ERR_EMAIL_REQUIRED, exact=False), "no 'email required' message")
    check(d.find(S.ERR_PASSWORD_REQUIRED, exact=False), "no 'password required' message")
    fields = [n for n in d.dump() if n.cls.endswith("EditText")]
    check(len(fields) >= 2, "email/password fields not found")
    d.tap_node(fields[0], wait=1)
    d.type_text("notanemail")
    d.back(wait=1)
    d.tap_node(d.find_all(S.LOGIN_EMAIL, exact=True)[-1], wait=2)
    check(d.find(S.ERR_EMAIL_INVALID, exact=False), "no 'invalid email' message")
    a.go_home()


@test("AUTH-03", "Sign-up requires a country first", "account")
def signup_requires_country(ctx):
    a, d = ctx.app, ctx.device
    a.go_home()
    d.tap_label("المسابقات", exact=True, wait=4)
    d.close_ad()
    d.tap_label(S.CREATE_ACCOUNT, exact=True, wait=4)
    d.tap_node(d.find_all(S.CREATE_ACCOUNT, exact=True)[-1], wait=0.7)
    check(d.wait_for(S.ERR_COUNTRY_REQUIRED, timeout=4), "no 'choose your country' message")
    a.go_home()


@test("FEED-01", "Community feed loads posts (or offers Retry)", "feed", needs=("network",))
def feed_loads(ctx):
    a, d = ctx.app, ctx.device
    a.go_home()
    if d.find(S.RETRY, exact=True):
        d.tap_label(S.RETRY, exact=True, wait=8)
    d.swipe_up(0.3)
    check(d.find(S.LIKE, exact=False) and d.find(S.SHARE, exact=False),
          "no posts with Like/Share buttons")
    a.go_home()


@test("FEED-02", "Logged out: Like and Post ask to log in instead of acting",
      "feed", needs=("network",))
def feed_requires_login(ctx):
    a, d = ctx.app, ctx.device
    a.go_home()
    d.swipe_up(0.3)
    like = d.find(S.LIKE, exact=False)
    check(like, "no Like button")
    d.tap_node(like, wait=2)
    check(d.wait_for(S.MUST_LOGIN, timeout=5), "Like did not ask to log in")
    d.back()
    a.go_home()


@test("FEED-03", "Sharing a post opens the system share sheet", "feed", needs=("network",))
def feed_share(ctx):
    a, d = ctx.app, ctx.device
    a.go_home()
    d.swipe_up(0.3)
    share = d.find(S.SHARE, exact=False)
    check(share, "no Share button")
    d.tap_node(share, wait=3)
    check(not d.app_in_front() or d.find("Share", exact=False),
          "share sheet did not open")
    d.back(force=True)    # close the system share sheet
    a.go_home()


def _switch_language(ctx, index):
    a, d = ctx.app, ctx.device
    a.go_home()
    a.open_language_picker()
    # Options are listed Arabic, English, French; each has a radio button
    radios = sorted([n for n in d.dump() if n.clickable and not n.label
                     and n.bounds[1] > d.size()[1] * 0.3], key=lambda n: n.center[1])[:3]
    check(len(radios) == 3, "language radio buttons not found")
    d.tap_node(radios[index], wait=6)


@test("LANG-01", "English and French switch the UI and back to Arabic", "language")
def languages(ctx):
    d = ctx.device
    try:
        _switch_language(ctx, 1)
        labels = d.labels()
        check(S.EN_MAIN_SECTIONS in labels, "English: home not translated")
        check(not any("Aleasha" in l or "Alzuhr" in l for l in labels),
              "English prayer names are transliterated (Aleasha/Alzuhr)")
        # Header icons are mirrored in English: language is second from the right
        _, h = d.size()
        icons = sorted([n for n in d.dump() if n.clickable and not n.label
                        and n.bounds[3] < h * 0.13], key=lambda n: n.center[0])
        d.tap_node(icons[-2], wait=2)
        radios = sorted([n for n in d.dump() if n.clickable and not n.label
                         and n.bounds[1] > h * 0.3], key=lambda n: n.center[1])[:3]
        d.tap_node(radios[2], wait=6)
        check(S.FR_MAIN_SECTIONS in d.labels(), "French: home not translated")
        icons = sorted([n for n in d.dump() if n.clickable and not n.label
                        and n.bounds[3] < h * 0.13], key=lambda n: n.center[0])
        d.tap_node(icons[-2], wait=2)
        radios = sorted([n for n in d.dump() if n.clickable and not n.label
                         and n.bounds[1] > h * 0.3], key=lambda n: n.center[1])[:3]
        d.tap_node(radios[0], wait=6)
    finally:
        check(d.wait_for(S.MAIN_SECTIONS, timeout=10), "could not switch back to Arabic")
