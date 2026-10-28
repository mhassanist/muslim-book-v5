"""App-level navigation on top of Device, shared by the test cases."""

import re
import time

from . import strings as S
from .device import Device, DeviceError


class App:
    def __init__(self, device: Device):
        self.d = device

    # ---- where are we ----------------------------------------------------

    def on_home(self, nodes=None) -> bool:
        return self.d.find(S.MAIN_SECTIONS, nodes=nodes) is not None

    def go_home(self, attempts=8):
        """Back out to the home screen from anywhere."""
        for _ in range(attempts):
            self.d.close_ad()
            other = self.d.foreign_app()
            if other:
                # Never relaunch over another app: someone may be using the phone
                raise DeviceError(f"{other} is in front; not navigating over it")
            nodes = self.d.dump()
            if self.d.find(S.EXIT_APP_QUESTION, nodes=nodes, exact=False):
                cancel = self.d.find(S.CANCEL, nodes=nodes, exact=True)
                if cancel:                 # dismiss "exit the app?"
                    self.d.tap_node(cancel)
                else:
                    self.d.back()
                continue
            if self.d.find(S.LEAVE_AZKAR, nodes=nodes):
                self.d.tap_label(S.EXIT, exact=True)
                continue
            if self.on_home(nodes):
                return
            home_tab = self._tab_node("الرئيسية", nodes)
            if home_tab:
                self.d.tap_node(home_tab)
                if self.on_home():
                    return
            self.d.back()
        if not self.on_home():
            raise DeviceError("could not get back to the home screen")

    # ---- header / tabs ---------------------------------------------------

    def header_buttons(self) -> list:
        """Unlabelled clickable icons in the home header, left to right
        (Arabic layout: settings, language, ..., menu)."""
        _, h = self.d.size()
        nodes = [n for n in self.d.dump()
                 if n.clickable and not n.label and n.visible and n.bounds[3] < h * 0.13]
        uniq = {}
        for n in nodes:
            uniq.setdefault(n.center[0] // 40, n)
        return sorted(uniq.values(), key=lambda n: n.center[0])

    def open_settings(self):
        self.go_home()
        self.d.tap_node(self.header_buttons()[0], wait=3)
        if not self.d.wait_for(S.SETTINGS, exact=True, timeout=10):
            raise DeviceError("settings did not open")

    def open_language_picker(self):
        self.go_home()
        self.d.tap_node(self.header_buttons()[1], wait=2)

    def open_menu(self):
        self.go_home()
        self.d.tap_node(self.header_buttons()[-1], wait=2)

    def _tab_node(self, label, nodes=None):
        for n in nodes if nodes is not None else self.d.dump():
            if n.label.startswith(label) and S.TAB_SUFFIX in n.label:
                return n
        return None

    def open_tab(self, label):
        node = self._tab_node(label)
        if not node:
            raise DeviceError(f"tab not found: {label}")
        self.d.tap_node(node, wait=3)
        self.d.close_ad()

    # ---- prayer times ----------------------------------------------------

    def open_prayer_times(self):
        self.go_home()
        self.d.tap_label(S.PRAYER_TIMES, wait=3)
        self.d.close_ad()
        if not self.prayer_row(S.PRAYERS["4"]):
            raise DeviceError("prayer times screen did not open")

    def prayer_row(self, name):
        for n in self.d.dump():
            if n.lines and n.lines[0] == name:
                return n
        return None

    def prayer_time(self, name) -> str:
        """'HH:MM' shown for a prayer on the prayer times screen."""
        row = self.prayer_row(name)
        if not row:
            raise DeviceError(f"prayer row not found: {name}")
        times = re.findall(r"\b\d\d:\d\d\b", row.label)
        return times[-1] if times else ""

    # ---- settings sections -----------------------------------------------

    def toggle_section(self, title):
        """Sections open from the arrow at the start of their header."""
        node = self.d.find(title, exact=True)
        if not node:
            self.d.swipe_up(0.3)
            node = self.d.find(title, exact=True)
        if not node:
            raise DeviceError(f"settings section not found: {title}")
        w, _ = self.d.size()
        self.d.tap(int(w * 0.1), node.center[1], wait=2.5)

    def section_value(self, title) -> str:
        """Label shown just under an expanded section header."""
        nodes = [n for n in self.d.dump() if n.label and n.visible]
        for i, n in enumerate(nodes):
            if n.label == title and i + 1 < len(nodes):
                return nodes[i + 1].label
        return ""

    def switches(self) -> list:
        return [n for n in self.d.dump() if n.checkable]

    # ---- pickers ---------------------------------------------------------

    def picker_selected(self) -> str:
        sel = [n for n in self.d.dump() if n.selected and n.label]
        return sel[0].label if sel else ""

    def picker_save(self):
        self.d.tap_label(S.SAVE, exact=True, wait=4)
        self.d.close_ad()

    def picker_load_more(self):
        if self.d.find(S.MORE_VOICES, exact=True):
            self.d.tap_label(S.MORE_VOICES, exact=True, wait=8)

    # ---- onboarding ------------------------------------------------------

    def complete_onboarding(self, check_validation=True) -> dict:
        """Walks the first-run flow. Returns observations for the tests."""
        seen = {}
        d = self.d
        if d.wait_for(S.ENABLE_AZAN, exact=True, timeout=15):
            d.tap_label(S.ENABLE_AZAN, exact=True, wait=4)
            if "settings" in d.top_activity().lower():
                d.back(force=True)    # overlay permission screen, already granted
                d.launch(wait=6)
        if not d.wait_for(S.LOCATION_TITLE, exact=True, timeout=20):
            seen["location_screen"] = False
            return seen
        seen["location_screen"] = True
        if check_validation:
            d.tap_label(S.SAVE_TIMING, wait=2)
            seen["err_no_country"] = d.find(S.ERR_NO_COUNTRY, exact=False) is not None
        d.tap_label(S.AUTO_LOCATE, wait=8)
        seen["location_text"] = next((n.label for n in d.dump()
                                      if " - " in n.label and n.label != S.AUTO_LOCATE), "")
        if d.find(S.METHOD_PLACEHOLDER, exact=True) and not d.find(S.EGYPTIAN_METHOD):
            if check_validation:
                d.tap_label(S.SAVE_TIMING, wait=2)
                seen["err_no_method"] = d.find(S.ERR_NO_METHOD, exact=False) is not None
            nodes = d.find_all(S.METHOD_PLACEHOLDER, exact=True)
            d.tap_node(nodes[-1], wait=2)
            d.tap_label(S.EGYPTIAN_METHOD, wait=2)
        d.tap_label(S.SAVE_TIMING, wait=6)
        if d.wait_for(S.ALLOW_NOTIFICATIONS, exact=True, timeout=10):
            d.tap_label(S.ALLOW_NOTIFICATIONS, exact=True, wait=3)
        for _ in range(3):  # system dialogs (battery optimisation, permissions)
            allow = d.find("Allow", exact=True) or d.find("السماح", exact=True)
            if not allow or d.top_activity().startswith(d.package) and d.find(S.MAIN_SECTIONS):
                break
            d.shell(f"input tap {allow.center[0]} {allow.center[1]}")
            time.sleep(3)
        d.close_ad()
        seen["home"] = d.wait_for(S.MAIN_SECTIONS, timeout=25) is not None
        return seen
