"""LOGIN: flows as a real logged-in user.

Run with --account FILE (email=... / password=... of a dedicated test
account, kept outside the repo). These write to the live server: login,
competition answers, and (only with --allow-posts) one public post.
"""

import re
import time

from harness import strings as S
from harness.runner import test, check, Skip


def _account(ctx):
    acc = ctx.options.get("account")
    if not acc:
        raise Skip("needs --account")
    return acc


def _logout_if_needed(ctx):
    a, d = ctx.app, ctx.device
    if not a.logged_in():
        return
    a.menu_item(S.LOGOUT)
    d.tap_label(S.YES, exact=True, wait=6)
    d.close_ad()
    a.go_home()


def _open_login_options(ctx):
    a, d = ctx.app, ctx.device
    a.go_home()
    d.tap_label(S.TILES[0], exact=True, wait=4)   # Competitions asks to log in
    d.close_ad()
    check(d.find(S.LOGIN_EMAIL, exact=True), "login options not shown")


@test("LOGIN-01", "Email login logs in", "logged-in", needs=("network",))
def email_login(ctx):
    acc = _account(ctx)
    a, d = ctx.app, ctx.device
    _logout_if_needed(ctx)
    _open_login_options(ctx)
    d.tap_label(S.LOGIN_EMAIL, exact=True, wait=4)
    fields = [n for n in d.dump() if n.cls.endswith("EditText")]
    check(len(fields) >= 2, "email/password fields not found")
    d.tap_node(fields[0], wait=1)
    d.type_text(acc["email"])
    d.shell("input keyevent 66")              # next field
    time.sleep(1)
    d.type_text(acc["password"])
    d.back(wait=1.5)                          # hide the keyboard
    d.tap_node(d.find_all(S.LOGIN_EMAIL, exact=True)[-1], wait=8)
    d.close_ad()
    check(a.logged_in(), "not logged in after submitting the email login")


@test("LOGIN-02", "Profile shows the user's scores", "logged-in", needs=("network",))
def profile_scores(ctx):
    _account(ctx)
    a, d = ctx.app, ctx.device
    check(a.logged_in(), "not logged in (LOGIN-01 failed?)")
    d.tap_node(a.header_buttons()[0], wait=7)     # avatar
    d.close_ad()
    labels = d.labels()
    check(S.PROFILE in labels, "profile did not open")
    check(not any(S.CANT_REACH in l for l in labels),
          "profile shows 'can't reach' (users/score failing, or an expired token)")
    check(any(S.COMPETITION_POINTS in l for l in labels), "scores not shown")
    a.go_home()


def _questions_left(d):
    for l in d.labels():
        m = re.search(S.QUESTIONS_LEFT, l)
        if m:
            return int(m[1])
    return None


@test("LOGIN-03", "Competitions: answering a question is saved", "logged-in",
      needs=("network",))
def competition_progress(ctx):
    _account(ctx)
    a, d = ctx.app, ctx.device
    a.go_home()
    d.tap_label(S.TILES[0], exact=True, wait=5)
    d.close_ad()
    before = _questions_left(d)
    if before is None:
        raise Skip("no competition intro (no questions left for this account?)")
    d.tap_label(S.START_NOW, exact=True, wait=6)
    d.close_ad()
    answers = [n for n in d.dump() if n.clickable and n.label
               and S.TAB_SUFFIX not in n.label and len(n.label) > 2][:4]
    check(answers, "no answers on the question screen")
    d.tap_node(answers[0], wait=3)
    check(d.find(S.NEXT_QUESTION, exact=True), "no 'next question' after answering")
    a.go_home()
    d.tap_label(S.TILES[0], exact=True, wait=5)
    d.close_ad()
    after = _questions_left(d)
    ctx.note(f"questions left {before} -> {after}")
    check(after is not None and after < before, f"progress not saved ({before} -> {after})")
    a.go_home()


@test("LOGIN-04", "Top users: menu entry reachable, leaderboard lists users",
      "logged-in", needs=("network",))
def leaderboard(ctx):
    _account(ctx)
    a, d = ctx.app, ctx.device
    a.open_menu()
    entry = d.find(S.TOP_USERS, exact=True)
    check(entry, "Top users is not visible in the menu without scrolling")
    d.tap_node(entry, wait=4)
    d.close_ad()
    d.tap_label(S.COMPETITION_BOARD, exact=True, wait=10)
    d.close_ad()
    rows = [l for l in d.labels() if re.match(r"\d+\n", l)]
    ctx.note(f"{len(rows)} ranked users visible")
    check(rows, "competition leaderboard is empty")
    a.go_home()


@test("LOGIN-05", "Posting publishes to the top of the feed", "logged-in",
      needs=("network",))
def post(ctx):
    _account(ctx)
    if not ctx.options.get("allow_posts"):
        raise Skip("needs --allow-posts (publishes to the live feed)")
    a, d = ctx.app, ctx.device
    a.go_home()
    tab = d.find(S.COMMUNITY, exact=True)
    check(tab, "community tab not found")
    d.tap(d.size()[0] // 2, tab.center[1] + 141, wait=4)   # post box under the tabs
    d.close_ad()
    field = next((n for n in d.dump() if n.cls.endswith("EditText")), None)
    check(field, "post editor did not open")
    d.tap_node(field, wait=1)
    d.type_text(S.TEST_POST)
    d.back(wait=1.5)
    d.tap_node(d.find_all(S.POST, exact=True)[-1], wait=8)
    d.close_ad()
    a.go_home()
    w, h = d.size()
    for _ in range(3):   # the feed scrolls inside the page; bring it to its top
        d.shell(f"input swipe {w // 2} {int(h * .6)} {w // 2} {int(h * .8)} 300")
        time.sleep(1.5)
    first = next((l for l in d.labels() if "\n" in l and S.TAB_SUFFIX not in l), "")
    ctx.note(first.replace("\n", " | ")[:60])
    check(S.TEST_POST in first, "the new post is not at the top of the feed")


@test("LOGIN-06", "Logout from the side menu", "logged-in")
def logout(ctx):
    _account(ctx)
    a, d = ctx.app, ctx.device
    check(a.logged_in(), "not logged in")
    a.menu_item(S.LOGOUT)
    check(d.find(S.LOGOUT_QUESTION, exact=False), "no logout confirmation")
    d.tap_label(S.YES, exact=True, wait=6)
    d.close_ad()
    check(not a.logged_in(), "still logged in after Logout")
    _open_login_options(ctx)
    a.go_home()


@test("LOGIN-07", "Google sign-in with the device's account", "logged-in",
      needs=("network",))
def google_login(ctx):
    email = ctx.options.get("google_account")
    if not email:
        raise Skip("needs --google-account")
    a, d = ctx.app, ctx.device
    _logout_if_needed(ctx)
    _open_login_options(ctx)
    d.tap_label(S.LOGIN_GOOGLE, exact=True, wait=8)
    pick = d.find(email, exact=True)
    if pick:   # account picker (skipped when Google remembers the choice)
        d.shell(f"input tap {pick.center[0]} {pick.center[1]}")
        time.sleep(12)
    d.close_ad()
    error = next((l for l in d.labels() if "image url" in l or "يجب" in l), "")
    check(not error, f"server rejected the Google login: {error}")
    check(a.logged_in(), "not logged in after Google sign-in")
    _logout_if_needed(ctx)


@test("LOGIN-08", "Facebook login reaches Facebook's consent page", "logged-in",
      needs=("network",))
def facebook_login(ctx):
    """Stops before consenting; fails if Facebook rejects the app itself."""
    a, d = ctx.app, ctx.device
    _logout_if_needed(ctx)
    _open_login_options(ctx)
    if not d.find(S.LOGIN_FACEBOOK, exact=True):
        raise Skip("Facebook login is hidden in this build")
    d.tap_label(S.LOGIN_FACEBOOK, exact=True, wait=5)
    # Wait for Facebook's page to settle: an error, or its login/consent form
    labels, message, ready = [], "", False
    for _ in range(20):
        if d.app_in_front():
            break
        labels = d.labels()
        message = next((l for l in labels if "not active" in l or "not currently" in l), "")
        ready = any(k in l for l in labels
                    for k in ("Continue", "Log in", "Log In", "متابعة", "تسجيل الدخول"))
        if message or ready:
            break
        time.sleep(1.5)
    # Close the browser tab this test opened, then confirm the app recovered
    close = d.find("Close tab", exact=True)
    if close:
        d.shell(f"input tap {close.center[0]} {close.center[1]}")
        time.sleep(3)
    elif not d.app_in_front():
        d.back(force=True, wait=3)
    check(d.app_in_front(), "app did not come back after closing Facebook")
    check(labels, "Facebook login did not open")
    check(message or ready, "Facebook's page did not finish loading")
    check(not message, f"Facebook rejected the app: {message[:120]}")
