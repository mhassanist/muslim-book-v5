"""QURAN / AZKAR / MORE / QIBLA: content screens."""

import re
import time

from harness import strings as S
from harness.runner import test, check, Skip


@test("QURAN-01", "Reading: index, open a surah, swipe pages, Back out", "quran")
def quran_reading(ctx):
    a, d = ctx.app, ctx.device
    a.go_home()
    d.tap_label("القرآن الكريم", wait=3)
    d.close_ad()
    d.tap_label(S.QURAN_READ, wait=4)
    d.close_ad()
    check(d.wait_for(S.QURAN_INDEX_TITLE, timeout=10), "Quran index did not open")
    check(d.find(S.SURAH_FATIHA, exact=False) and d.find(S.SURAH_BAQARA, exact=False),
          "surah list empty")
    d.tap_node(d.find(S.SURAH_BAQARA, exact=False), wait=8)
    page = next((l for l in d.labels() if re.fullmatch(r"\d+", l)), None)
    check(page == "2", f"Al-Baqarah did not open on page 2 (title {page!r})")
    w, h = d.size()
    d.shell(f"input swipe {int(w * .2)} {h // 2} {int(w * .85)} {h // 2} 300")
    time.sleep(4)
    page2 = next((l for l in d.labels() if re.fullmatch(r"\d+", l)), None)
    check(page2 == "3", f"swiping did not go to page 3 (title {page2!r})")
    d.back(wait=2.5)
    d.close_ad()
    check(d.find(S.QURAN_INDEX_TITLE, exact=False), "Back from the reader did not return "
                                                   "to the index")
    a.go_home()


@test("QURAN-02", "Listening: surah list and verses load", "quran", needs=("network",))
def quran_listening(ctx):
    a, d = ctx.app, ctx.device
    a.go_home()
    d.tap_label("القرآن الكريم", wait=3)
    d.close_ad()
    d.tap_label(S.QURAN_LISTEN, wait=5)
    d.close_ad()
    fatiha = d.wait_for("Al-Faatiha", timeout=15)
    check(fatiha, "surah list did not load")
    d.tap_node(fatiha, wait=8)
    verses = [l for l in d.labels() if re.search(r"\s\d+$", l)]
    check(len(verses) >= 3, "verses did not load")
    ctx.note(f"{len(verses)} verses visible")
    a.go_home()


@test("AZKAR-01", "Azkar: counter counts, advances, and leaving asks first", "azkar")
def azkar_counter(ctx):
    a, d = ctx.app, ctx.device
    a.go_home()
    d.tap_label("الأذكار", wait=3)
    d.close_ad()
    d.tap_label(S.MORNING_AZKAR, wait=4)
    d.close_ad()
    rep = d.wait_for(S.REPEAT, timeout=8)
    check(rep, "dhikr screen did not open")
    times = int(re.search(r"\d+", rep.label)[0])
    counter = next((n for n in d.dump() if n.clickable and re.fullmatch(r"\d+", n.label)), None)
    check(counter and counter.label == "0", "counter not at 0")
    first_text = next((l for l in d.labels() if len(l) > 30), "")
    for i in range(1, times):
        d.tap_node(counter, wait=1)
        counter = next(n for n in d.dump() if n.clickable and re.fullmatch(r"\d+", n.label))
        check(counter.label == str(i), f"counter shows {counter.label}, expected {i}")
    d.tap_node(counter, wait=2)
    next_text = next((l for l in d.labels() if len(l) > 30), "")
    check(next_text != first_text, "did not move on to the next dhikr after the last count")
    d.back(wait=2)
    check(d.find(S.LEAVE_AZKAR, exact=False), "no confirmation when leaving azkar")
    d.tap_label(S.CONTINUE, exact=True, wait=2)
    check(d.find(S.REPEAT, exact=False), "'Continue' did not stay on the dhikr")
    d.back(wait=2)
    exits = d.find_all(S.EXIT, exact=True)
    d.tap_node(exits[-1], wait=3)
    check(d.find(S.MORNING_AZKAR, exact=True), "'Exit' did not return to the azkar list")
    a.go_home()


@test("MORE-01", "More: every category opens with content", "more", needs=("network",))
def more_categories(ctx):
    a, d = ctx.app, ctx.device
    a.go_home()
    d.tap_label(S.MORE_TITLE, exact=True, wait=3)
    d.close_ad()
    failed = []
    for cat in S.MORE_CATEGORIES:
        node = d.find(cat, exact=True)
        if not node:
            d.swipe_up(0.3)
            node = d.find(cat, exact=True)
        if not node:
            failed.append(f"{cat} (not listed)")
            continue
        d.tap_node(node, wait=4)
        d.close_ad()
        title_ok = d.wait_for(cat, timeout=8, exact=True)
        content = [l for l in d.labels() if len(l) > 20 and "Ad" not in l]
        if not title_ok or not content:
            failed.append(cat)
        d.back(wait=2)
        d.close_ad()
        if not d.find(S.MORE_TITLE, exact=True):
            a.go_home()
            d.tap_label(S.MORE_TITLE, exact=True, wait=3)
            d.close_ad()
    check(not failed, "categories without content: " + ", ".join(failed))
    a.go_home()


@test("MORE-02", "More: an item opens its full text", "more", needs=("network",))
def more_detail(ctx):
    a, d = ctx.app, ctx.device
    a.go_home()
    d.tap_label(S.MORE_TITLE, exact=True, wait=3)
    d.close_ad()
    d.tap_label("أدعية للميت", exact=True, wait=4)
    d.close_ad()
    more = d.wait_for(S.SHOW_MORE, timeout=10)
    check(more, "'show more' link missing")
    d.tap_node(more, wait=4)
    d.close_ad()
    check(any(len(l) > 60 for l in d.labels()), "detail text not shown")
    a.go_home()


@test("QIBLA-01", "Qibla screen opens", "qibla")
def qibla(ctx):
    a, d = ctx.app, ctx.device
    a.go_home()
    d.tap_label("اتجاة القبلة", exact=True, wait=4)
    d.close_ad()
    check(d.wait_for(S.QIBLA_CALIBRATE, timeout=10), "compass screen did not open")
    a.go_home()
