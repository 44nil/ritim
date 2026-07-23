---
name: run-ritim
description: Build, run, and drive the Ritim Flutter app (period tracker) on the iOS Simulator. Use when asked to start ritim, run it, build it, take a screenshot of its UI, or interact with the running app.
---

Ritim is a Flutter mobile app (iOS/Android/web/macOS targets exist, iOS Simulator is the verified path). Drive it via the Flutter-native `integration_test` harness at `integration_test/app_test.dart` — it taps widgets by text/key through the Dart VM service, so it needs no screen coordinates and works even if the Simulator window isn't visible on screen. Take screenshots via `xcrun simctl io <udid> screenshot`, which also works independent of window visibility.

All paths below are relative to `ritim/` (this repo root).

## Prerequisites

macOS with Xcode + an iOS Simulator runtime installed, and Flutter 3.44.1 (stable channel) on PATH. No Linux/headless path exists for this project — it's a mobile app, iOS Simulator is required for the verified flow below.

```bash
flutter devices   # confirm at least one iOS simulator is listed
```

## Setup

```bash
flutter pub get
```

## Run (agent path)

**1. Check for accidentally-deleted native files first** (see Gotchas — this repo has hit this twice):

```bash
git status --porcelain=v1 -- ios/ macos/ android/
# if anything shows " D <path>", restore it:
git checkout -- <path>
```

**2. Drive it deterministically** (no screen coordinates, no window-visibility dependency):

```bash
flutter test integration_test/app_test.dart -d <device-id>
```

Get `<device-id>` from `flutter devices` (e.g. the iPhone simulator's UDID). This builds, installs, launches the app, taps through onboarding via `find.text('Atla')`, and asserts the home tab (`Döngüm`) and mock cycle data (`Ovülasyon`) render. Exit code 0 + `All tests passed!` = the app boots and the core nav flow works.

**3. For an interactive session / to take screenshots of specific screens:**

```bash
flutter run -d <device-id>          # launches, stays attached, hot reload with 'r'
xcrun simctl io <device-id> screenshot /tmp/ritim_screens/<name>.png
```

The `simctl io screenshot` command reads the simulator's framebuffer directly — it works even when the Simulator.app window is on a different Space or not frontmost, so it's safe to call without touching focus.

**Do not** try to drive the UI via real mouse clicks / `cliclick` / AppleScript coordinates — see Gotchas.

**4. Use a dedicated simulator for your own verification when the user is watching a `flutter run` session on another device** — see the "two devices" Gotcha below. Don't run `flutter test`/`flutter run` against the same device UDID the user is actively looking at.

## Run (human path)

`flutter run -d <device-id>` from the repo root, same as above — a real Simulator window opens. `r` hot-reloads, `q` quits.

## Test

```bash
flutter test integration_test/app_test.dart -d <device-id>   # integration/e2e smoke test
flutter analyze --no-pub                                      # lint, must be 0 issues
```

`test/widget_test.dart` is a minimal separate smoke test (pumps `RitimApp`, asserts `MaterialApp` renders) — run with plain `flutter test test/widget_test.dart` (no device needed, runs on the host VM).

---

## Gotchas

- **Native iOS files go missing from the working tree** (`ios/Flutter/Debug.xcconfig`, `ios/Runner/AppDelegate.swift`, `ios/Runner/Base.lproj/LaunchScreen.storyboard`, `ios/Runner/SceneDelegate.swift`) — hit this on a clean run: `flutter run` failed first with `Unable to open base configuration reference file '.../Debug.xcconfig'`, then after restoring that one, failed again with `Build input file cannot be found: '.../LaunchScreen.storyboard'`. All four were tracked in git but absent from disk (`git status` showed them as `D`). Fix: `git checkout -- <path>` for each. Always run the `git status --porcelain -- ios/` check above before assuming a build failure is a real code problem.
- **Screen-coordinate mouse automation (`cliclick`/AppleScript) is unreliable here** — the Simulator window's reported AppleScript position didn't match where it actually rendered on screen (multi-Space / HiDPI scaling confusion on this machine), and a computed click landed on a *different, unrelated app window* instead of the Simulator. Verified this by cropping a screenshot at the computed click coordinates before clicking — it showed the wrong window. Use `integration_test` (widget-tree taps by text/key) instead; it's immune to this entirely since it never touches screen pixels.
- **Multiple Simulator devices are registered** (iPhone 17 Pro Max simulator, a wireless physical iPhone, macOS desktop, Chrome web) — always pass an explicit `-d <device-id>`, don't rely on the default device.
- **Running `flutter test`/`flutter run` against the same simulator the user is actively watching kills their session** — `flutter test` installs+relaunches the app (evicting any `flutter run` session) and always terminates the app on `tearDownAll` when it finishes, so the user sees the app vanish back to the Home Screen. Once the user is interacting with `flutter run` on one device (e.g. iPhone 17 Pro Max, `8C7A8725-C1EF-45F9-940C-59F6015C6664`), boot a second, separate simulator for your own verification runs: `xcrun simctl boot <other-udid>` (e.g. iPhone 17 Pro, `BFACD649-7C14-4469-90E9-5FE3F803FD17`), then pass that UDID to your own `flutter test`/screenshot commands. Never verify on the device the user is currently looking at.
- **Getting a screenshot mid-test requires a temporary artificial delay, and the timing is easy to lowball.** To screenshot a screen reached via `integration_test`, temporarily add `await Future.delayed(const Duration(seconds: 25));` right after the assertions for that screen, run the test in the background, *then* immediately run `xcrun simctl io <udid> screenshot ...`. 8 seconds was too tight. **`flutter test` does not print matched widget text/assertion content to stdout** — you cannot `grep` for a screen's on-screen text to know when it's reached. Instead grep for `"Xcode build done"` (which *does* print), then sleep a few extra seconds to cover the UI steps before the artificial delay window, then screenshot. Always revert the temporary delay afterward.
- **A booted simulator does not necessarily stay booted between sessions** — after enough wall-clock time passes (e.g. an overnight gap), a previously-booted UDID may show as `Shutdown` again (`xcrun simctl list devices`). Always check/`xcrun simctl boot <udid>` before assuming a device from an earlier turn is still up; `flutter test -d <udid>` fails immediately with "No supported devices found" otherwise.
- **`AppRouter.router` is a `static final GoRouter` singleton — its navigation location persists across separate `testWidgets` blocks in the same test run.** A second `testWidgets` that calls `tester.pumpWidget(RitimApp())` again does NOT restart at `/onboarding`; it resumes wherever the router was left by the previous test (e.g. already past onboarding), so `find.text('Atla')` fails with "Found 0 widgets". Keep one continuous flow in a single `testWidgets` block instead of splitting navigation steps across multiple blocks.
- **`pumpAndSettle()` hangs forever (multi-minute, effectively permanently) if an indeterminate `CircularProgressIndicator` (or any non-terminating animation) is on screen** — it never "settles" since the spinner animates continuously. Hit this tapping the parent-login "Giriş Bağlantısı Gönder" button, which shows a loading spinner for a fake 1200ms delay. Fix: after the tap, use `await tester.pump(); await tester.pump(const Duration(milliseconds: 1300));` to advance past the fixed delay, *then* `pumpAndSettle()`. If a test hangs this way, kill it with `pkill -9 -f "flutter test integration_test"` (and `pkill -9 -f "xcodebuild.*Runner"` if the build is also stuck).
- **Tapping a widget that's below the fold on a scrollable screen fails silently-ish** — `tap()` finds the widget but logs a hit-test warning ("would not hit test... offset is outside the bounds of the root of the render tree") and the tap lands nowhere, so the next step fails with a confusing unrelated error (e.g. "Bad state: No element" from `enterText` because navigation never happened). Fix: `await tester.ensureVisible(find.text('...')); await tester.pumpAndSettle();` before tapping anything that might be off-screen (e.g. the "Ebeveyn Paneli" row on the Profil tab).

## Troubleshooting

- **`Error (Xcode): Unable to open base configuration reference file '.../ios/Flutter/Debug.xcconfig'`**: file deleted from working tree but still tracked. `git checkout -- ios/Flutter/Debug.xcconfig`.
- **`Build input file cannot be found: '.../ios/Runner/Base.lproj/LaunchScreen.storyboard'`** (`Command Ld failed`): same cause, different file. `git checkout -- ios/Runner/Base.lproj/LaunchScreen.storyboard ios/Runner/AppDelegate.swift ios/Runner/SceneDelegate.swift` (check `git status` for the full list, it's not always just one file).
- **Tapping via `cliclick` does nothing and the screenshot shows no change**: don't debug coordinates — switch to the `integration_test` driver above.
