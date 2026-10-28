# Muslim Book regression test cases

Every case below is either **automated** (run by `run.py`, see [README](README.md)) or
**manual** (needs a person, a real account or real time to pass). Run both before
each release.

"Guards" notes the real bug a case was written for, so a failure there means that
bug is back.

## Automated

### Release artifact (no device needed)

| ID | Steps | Expected | Guards |
|---|---|---|---|
| REL-01 | Read the APK's version | versionCode > 4023 and > `--min-version-code` | Users on old per-ABI APKs (1023–4023) couldn't update |
| REL-02 | Read SDK levels | target ≥ 36, min ≤ 24 | Play rejects target < 36; 1,058 Android 6 devices already dropped |
| REL-03 | `zipalign -P 16`, `llvm-readelf` on arm64 libs | All aligned to ≥ 16 KB | Play's 16 KB page-size requirement |
| REL-04 | `apksigner verify` | Signed, not with the debug key | Uploading a debug-signed build |

### Install and first run

| ID | Steps | Expected | Guards |
|---|---|---|---|
| INS-01 | Uninstall, install the APK, grant permissions, launch | App in front, no crash or Flutter error in the log | Release-only shrinker crashes: WorkManager DB, Firebase components |
| ONB-01 | Onboarding: Save with no location, auto-locate, Save with no method (if not preset), pick Egyptian, Save, allow notifications/battery | Both validation messages appear; location shown; home reached | Onboarding regressions; crash saving the location (stripped strings) |
| ONB-02 | Read `dumpsys alarm` | An azan alarm is registered | Azan never scheduled after setup |
| INS-02 | Force-stop, relaunch | Azan alarm registered again | App left "stopped" dropped its own broadcast, no alarm |

### Home and navigation

| ID | Steps | Expected | Guards |
|---|---|---|---|
| HOME-01 | Open home | Next-prayer card, 6 section tiles, Islamiyat/Community tabs | Broken home layout |
| HOME-02 | Read the countdown | `HH:MM:SS` | Known bug: shows `010:02:52` when > 10 h remain |
| NAV-01 | Tap each bottom tab | Quran, Qibla, Competitions (login), Azkar, Home screens | Tab routing |
| NAV-02 | Back on home | "Exit the app?" confirmation | Accidental exits |
| NAV-03 | Header settings icon | Settings opens | |
| NAV-05 | Open the side menu, press Back | Menu closes, no exit prompt | Back asked to exit with the menu open (PopScope blocked the drawer) |
| NAV-04 | Header language icon | Arabic / English / French offered | |
| MENU-01 | Open side menu | All 11 entries listed | |
| MENU-02 | Menu → Top users | Both leaderboards | |
| MENU-03 | Menu → Usage policy | VIEW intent for the policy URL is launched | Policy link silently doing nothing |

### Prayer times and the azan

| ID | Steps | Expected | Guards |
|---|---|---|---|
| PT-01 | Open prayer times | 6 prayers with valid `HH:MM` times | Empty/garbled timetable |
| PT-02 | Tap the Fajr row, then the Asr row | Fajr muezzin picker; regular muezzin picker | |
| PT-03 | Share icon → "Share the app" | System share sheet | |
| AZAN-01 | Fire the azan for prayers 1, 3, 4, 5, 6 (same intent as the alarm) | Each starts and logs the sound file it plays | Azan silently failing to start |
| AZAN-02 | Fire Asr, read alarms while it plays | Next prayer already scheduled | Chain stopped when an azan was muted/unplayed |
| AZAN-03 | Fire Maghrib, send the close action | Audio stops | |

### Muezzin selection

| ID | Steps | Expected | Guards |
|---|---|---|---|
| MZ-01 | Settings → Azan muezzin and Fajr muezzin sections | Each shows a name | Hidden/crashing Settings sections |
| MZ-02 | Settings → choose Mustafa Ismail → Save; fire Asr and Maghrib | Section shows Mustafa; both play `azan_3.mp3`; (debug) saved for prayers 2–6 | |
| MZ-03 | Prayer times → Asr picker | Mustafa highlighted | Picker read a different key than Save wrote |
| MZ-04 | Asr picker → Al-Aqsa → Save; fire Asr and Maghrib | Asr plays `azan_4.mp3`, Maghrib still `azan_3.mp3`; Asr picker highlights Al-Aqsa | |
| MZ-05 | Settings → more voices → a downloaded muezzin → Save; fire Asr and Maghrib | Section shows it; both play the same `azan_sound<id>.mp3` | |
| MZ-06 | Prayer times → Maghrib picker | Downloaded choice highlighted | |
| MZ-07 | Fire Fajr; Settings → Fajr muezzin → a downloaded voice → Save; fire Fajr; Fajr picker | File changes to `azan_sound<id>`; section and picker show the choice | Built-in Fajr pick ignored after a download |
| MZ-08 | Rapid-tap 4 muezzins in a picker | Only the last is selected/playing | Previews stuck on an earlier tap |

### Settings

| ID | Steps | Expected | Guards |
|---|---|---|---|
| SET-01 | Open Settings, scroll to the end | 7 sections; "الإصدار <name> (<code>)" matches the installed build | |
| SET-02 | Notifications → flip each of the 4 switches twice | Each toggles and restores | |
| SET-03 | Country → auto-locate | Place shown | |
| SET-04 | Read Asr; Method → Hanafi → Save; read Asr; back to Shafi'i | Asr later with Hanafi **without restarting**; restored after | Times frozen until restart; azan not rescheduled |
| SET-05 | Correction → open editor → +2 on Asr → Save; read Asr; revert | Counter shows 2; returns to Settings; Asr +2 min; (debug) `update4 = 2` | +/− did nothing; editor trapped scrolling; Save closed Settings |
| SET-06 | Open the correction editor | All 6 prayer rows visible | Last row (Isha) cut off |

### Content

| ID | Steps | Expected | Guards |
|---|---|---|---|
| QURAN-01 | Quran → Reading → Al-Baqarah → swipe → Back | Page 2, then 3; Back returns to the index | Back trapped in the reader; blank index |
| QURAN-02 | Quran → Listening → Al-Fatiha | Verse list loads | Dead audio CDN |
| AZKAR-01 | Morning azkar → tap counter to the repeat count → Back → Continue → Back → Exit | Counts 0..n−1, advances to the next dhikr; confirmation; Continue stays; Exit returns to the list | Counter stuck (page remounting) |
| MORE-01 | More → open each of the 12 categories | Title and content for every one | |
| MORE-02 | More → Prayers for the deceased → Show more | Full text | |
| QIBLA-01 | Open Qibla | Compass calibration screen | |

### Account (logged out), feed, language

| ID | Steps | Expected | Guards |
|---|---|---|---|
| AUTH-01 | Open Competitions and Sebha logged out | Facebook / Google / email / create-account options | |
| AUTH-02 | Email login: submit empty; enter `notanemail` | Required-field messages; "invalid email" | |
| AUTH-03 | Create account: submit empty | "Choose your country" | |
| FEED-01 | Community feed (Retry if offline) | Posts with Like/Share | Infinite loading when the API is down |
| FEED-02 | Like a post while logged out | "You must log in" sheet | Fake local like that never reached the server |
| FEED-03 | Share a post | System share sheet | |
| LANG-01 | Switch to English, then French, then Arabic | Translated home; no "Aleasha/Alzuhr"; back to Arabic | Broken translations |

### Logged in (needs `--account`)

These write to the live server. LOGIN-06..08 leave the app logged out.

| ID | Steps | Expected | Guards against |
|---|---|---|---|
| LOGIN-01 | Log out if needed; Competitions → email login with the test account | Avatar appears in the header | |
| LOGIN-02 | Tap the avatar | Profile with "نقاط المسابقات", no "لا يمكن الوصول" | Score endpoint failing / stale token |
| LOGIN-03 | Competitions → Start → answer one question; reopen Competitions | "Next question"; questions-left count goes down | Progress not saved |
| LOGIN-04 | Open the side menu | "الأوائل" visible without scrolling; competition leaderboard lists users | Entry below the fold on small phones (G501) |
| LOGIN-05 | Post `Alhamdulillah` (only with `--allow-posts`); scroll the feed to its top | The post is first | |
| LOGIN-06 | Menu → Logout → Yes | Confirmation shown; avatar gone; Competitions asks to log in | Missing Logout |
| LOGIN-07 | Google sign-in (only with `--google-account`) | Logged in; no "image url" error | Server rejecting accounts without a photo |
| LOGIN-08 | Facebook login (stops before consenting) | Facebook's page opens; it doesn't say the app is not active; Back returns to the app | Deactivated Meta app |

### Stress

| ID | Steps | Expected |
|---|---|---|
| STRESS-01 | `monkey` with N random events, restricted to the app | No crash, no ANR |

## Manual (before every release)

These need a person, a real account, real time passing, or would write to the live
server. Tick them on a real phone with the **release** build.

| ID | Check | Why it isn't automated |
|---|---|---|
| M-01 | Leave the phone locked with the screen off through a real prayer time: the azan plays on time, with the reminder 10 minutes before | Needs real time, Doze and OEM battery behavior |
| M-02 | Reboot the phone; the next azan still plays | Rebooting mid-run is slow and unreliable |
| M-03 | Phone on silent / Do Not Disturb at prayer time: no sound, and the **next** prayer still plays | Depends on device sound settings |
| M-04 | Listen to: an azan, a muezzin preview, a Quran verse | Some devices don't report preview playback through `dumpsys` (see README) |
| M-05 | Finish a Facebook login (consent) and a Google login with an account that has a photo | Real accounts; LOGIN-07/08 cover the rest |
| M-06 | Logged in: like/unlike, online Sebha counter, profile share buttons (WhatsApp/Facebook/Twitter; stop at the compose screen) | Writes to the live server / other apps |
| M-07 | Ads: banners and interstitials show real ads (not "Test Ad"); no ad next to exit dialogs; EU consent form if in the EEA | Test devices only get test ads |
| M-08 | Push notification arrives and opens the right post | Needs the backend to send one |
| M-09 | Ramadan features (cannon, suhoor) during Ramadan | Seasonal |
| M-10 | Morning/evening azkar reminders and fasting (Mon/Thu, white days) alerts arrive | Real time |
| M-11 | Phone and tablet, Android 7 and the latest Android: layouts look right, edge-to-edge bars, predictive Back | Visual |
| M-12 | Upgrade install over the previous Play version: settings, muezzin choices and alarms survive | Needs the previous signed build |
| M-13 | Play Console pre-launch report and Android vitals: no new crashes/ANRs | External |

## Known issues the suite currently flags

| ID | Issue |
|---|---|
| HOME-02 | The countdown shows `010:02:52` when more than 10 hours remain |
| LOGIN-02 | Right after logging in, the profile shows "can't reach"; after an app restart it loads (seen on the G501, 2026-10-28; cause not found yet) |
| LOGIN-08 | Facebook shows "App not active": the Meta developer app is deactivated (fix in the Meta console) |

Other gaps found in testing that no test covers: no way to delete an account (Google
Play requires one), likes are never saved on the server, Back doesn't close the
competitions intro popup (only Skip), and the app doesn't recover from an expired token
until it is restarted.
