# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands
- `flutter analyze --no-pub` — lint, must pass 0 issues
- `flutter run` — run on device/sim
- No tests yet. No CI.

## What This Is
Flutter period tracker for Turkish girls 10-17. All UI Turkish. No backend yet — state in Riverpod, in-memory. No adult health metrics (fertility/ovulation windows). Warm, simple language.

## Architecture
Feature-based: `lib/core/`, `lib/features/`, `lib/shared/widgets/`.
- Router: `go_router` + `StatefulShellRoute` (5-tab bottom nav). Routes in `core/router/`.
- State: `flutter_riverpod`. `cycleProvider` (period records, daily logs, predictions). `themeModeProvider` (light/dark).
- Cycle logic: `CycleState` has `List<PeriodRecord>`. Soft predictions only with 3+ cycles. Uses `ProviderScope.containerOf(context)` in static methods.

## Design
Two colors: pink `#F472B6` + peach `#FBB47C`. Ink `#2D2438`. Gradients in `AppColors`.
Three fonts: Abril Fatface (headings via `AppTextStyles.heading()`), Dancing Script (accent via `AppTextStyles.accent()`), Poppins (body via theme).
Cards: 28dp radius, pink/orange tinted alternating. Nav bar: gradient floating bar.
Use `withValues(alpha:)` not `withOpacity()`. Background: white. Turkish locale `'tr_TR'` everywhere.

## Not Built
No persistence (resets on restart). No backend (Supabase planned). No article detail page. Quiz sets stub. Profile settings stub. No notifications. No app icon/splash.
