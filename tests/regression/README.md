# Regression suite

Automated end-to-end checks for Muslim Book, run on a real Android device (or
emulator) over adb before each release. The full list of cases, plus the manual
checklist, is in [TEST_CASES.md](TEST_CASES.md).

It drives the app the way a person does (taps, Back, swipes) and also checks things
only visible to Android: registered azan alarms, which sound file the azan plays,
crashes in the log. Test the **release** APK: several bugs only appear in release
builds (code and resource shrinking).

## Requirements

- Python 3.9+ (standard library only)
- `adb` on the PATH, Android SDK build-tools (for the APK checks; set `ANDROID_HOME`
  if the SDK isn't in `~/Library/Android/sdk`)
- One device connected, **unlocked, no PIN**, with internet and location on
- Arabic is the app language during the run (a fresh install starts in Arabic)

The device's app data is wiped: the suite uninstalls and installs the APK fresh.

## Running

```bash
flutter build apk --release
python3 tests/regression/run.py --apk build/app/outputs/flutter-apk/app-release.apk \
    --min-version-code 5002          # last code you released
```

Takes about 30–45 minutes. Useful options:

| Option | |
|---|---|
| `--list` | List all tests |
| `--only MZ,SET-04` | Run some tests or groups (an ID, its prefix, or a group) |
| `--skip stress` | Skip tests or groups |
| `--no-install` | Test the installed app as is (no fresh install/onboarding) |
| `--offline` | Skip tests that need the internet |
| `--monkey 500` | Number of random stress events (0 to skip) |
| `--device SERIAL` | Pick a device when several are connected |
| `--account FILE` | Enable the logged-in tests (LOGIN-*); FILE has `email=...` and `password=...` lines. Keep it outside the repo |
| `--google-account EMAIL` | Also test Google sign-in with this account (must be on the phone) |
| `--allow-posts` | Let LOGIN-05 publish `Alhamdulillah` to the live feed |

Exit code is 0 only when nothing failed.

Logged-in tests use a dedicated test account on the **live** server. Every login
issues a new token and invalidates the account's older ones, so don't use an account
that is logged in on someone's phone. Run them on a dedicated phone, e.g.:

```bash
python3 tests/regression/run.py --no-install --only logged-in --account ~/.muslimbook-test-account
```

## Reports

`tests/regression/out/<time>/`:

- `report.md`: one line per test with notes (for example which azan file played)
- `junit.xml`: for CI
- `screens/<ID>.png` and `screens/<ID>.log`: screenshot and logcat for every failure

## Debug vs release builds

On a debug build the suite also reads the app's saved settings (for example that a
muezzin was saved for prayers 2–6). On a release build those extra assertions are
skipped, and everything is checked through the screen and the azan log instead.

## How it works

- `harness/device.py`: adb, screen reading (`uiautomator dump`, which exposes
  Flutter's semantics labels), taps, logcat, alarms, audio state.
- `harness/app.py`: app navigation (go home, open settings, sections, pickers,
  onboarding).
- `harness/strings.py`: **every Arabic label the suite looks for**. When a label
  changes in `assets/langs/ar.json`, update it here.
- `cases/`: the tests, run in file order (`c00`…`c99`).

Rules the harness follows:

- Elements are found by label, never fixed coordinates (layouts shift with ads,
  insets and language). Unlabelled icons are found by position relative to the
  screen (for example the header icons, left to right).
- It never taps while an ad is in front (that would be an ad click), and closes
  interstitials with their close button or Back after the countdown.
- The azan is started with the same intent its alarm sends
  (`AzanReceiver`, `open_azan=true`, `nextAzanKEY=<prayer>`). The azan service logs
  `MuslimBookAzan: key=<prayer> file=<sound file>`, which the muezzin tests read.

## Adding a test

```python
from harness import strings as S
from harness.runner import test, check

@test("SET-07", "What it checks", "settings", needs=("network",))
def my_test(ctx):
    a, d = ctx.app, ctx.device
    a.open_settings()
    check(d.find(S.SEC_GENERAL, exact=True), "general settings missing")
    a.go_home()   # leave the app on the home screen for the next test
```

Add it to [TEST_CASES.md](TEST_CASES.md) too.

## Troubleshooting

- **Locked device**: remove the PIN on the test phone; the suite can't type it.
- **Emulator**: works, but Google Play emulator images can get very slow after a
  reboot (Play updates); prefer a physical phone.
- **Audio not detected**: some devices don't report audio from the preview player
  (`audioplayers`) in `dumpsys audio`, even though it plays. MZ-08 only notes this;
  confirm by ear (manual M-04).
- **A label not found**: the screen probably changed; check the failure screenshot
  and update `harness/strings.py` or the test.
