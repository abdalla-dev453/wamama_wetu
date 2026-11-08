# wamama_wetu
# ChamaLedger

Record-keeping, governance and M-Pesa reconciliation for Kenyan chamas, table
banking and merry-go-round groups. The app never holds customer funds.

Contains the **project scaffold, the design system and the Home dashboard**.
Ledger, offline queue and M-Pesa layers come next (folders already exist).

## Run

```bash
flutter create . --platforms=android   # first time only: generates android/
flutter pub get
flutter run                            # opens Home (Treasurer, mock data)
flutter test                           # contrast + widget tests
```

Requires Flutter >= 3.27 (uses `CardThemeData`, `Color.withValues`).

### Inter font
Add the four Inter `.ttf` files to `assets/fonts/` and uncomment the `fonts:`
block in `pubspec.yaml` (see `assets/fonts/README.md`). Until then the system
font is used.

## Design system (`lib/core/theme`, `lib/core/widgets`)

| File | Purpose |
|---|---|
| `app_colors.dart` | Brand tokens, light + dark `ColorScheme`, `AppSemanticColors` extension (success/warning/danger/info/neutral) |
| `app_typography.dart` | Inter 30/24/20/17/16/13 + tabular money style, mapped to M3 `TextTheme` |
| `app_spacing.dart` | 4-pt spacing scale, touch-target sizes, `AppMotion` (150–250 ms, respects "remove animations") |
| `app_radius.dart`, `app_shadows.dart` | Radius (12 buttons/inputs, 16 cards) and restrained elevation |
| `app_theme.dart` | `AppTheme.light` / `AppTheme.dark`, `context.semantic` / `context.colors` helpers |

Widgets (`import 'core/widgets/widgets.dart'`): `AppButton`, `AppChip`,
`AppCard`, `StatCard`, `MoneyText`, `MoneyField`, `AppTextField`,
`StatusBadge`, `SyncStatusBadge`, `OfflineBanner`, `EmptyState`,
`ErrorState`, `AppListTile`, `InitialsAvatar`, `SectionHeader`.

### Rules baked in
- Money is **integer cents** everywhere (`MoneyFormat`, `MoneyText`); no doubles.
- Status is always icon + text + tone, never colour alone.
- Credits/debits carry a `+` / `−` sign; negative balances carry `−`.
- Inputs use a darker border (`inputBorder`, >= 3:1) than the decorative card
  outline `#DDE1E6` (1.3:1, per brief, decorative only).
- Text scale supported up to 2.0x (`AppTypography.maxTextScale`).

### Deviations from the brief (needed for WCAG AA)
- `#B7791F` text on `#FFF3D6` is 3.3:1, so warning text uses `#5C3B08` (9.1:1).
- White on `#B7791F` is 3.6:1, so `onTertiary` is `#111827` (4.9:1).
- Added `onDangerContainer`, `onInfoContainer`, `inputBorderLight`, and a dark palette.

## Folder structure

```
lib/
  core/        theme/ widgets/ utils/ config/ router/
  features/    auth groups members contributions fines ledger mpesa
               rotation loans reports settings   (each: domain/ data/ presentation/)
               design_gallery/   (dev-only style guide)
```

## Environment
Not used yet. Backend URL will come from `--dart-define=API_BASE_URL=...`.

## Home dashboard (`lib/features/home`)

```
domain/         DashboardSummary entities, DashboardRepository (read-only
                interface), DashboardPermissions (role -> what is visible)
data/           MockDashboardRepository (demo data, role-filtered like the API)
presentation/   HomeScreen, providers/dashboard_providers.dart, widgets/
```

- **Repository seam:** `dashboardRepositoryProvider` returns the mock. To go
  live, override it with an API-backed repository (`GET /groups/{id}/dashboard`,
  read from the Drift cache first). The interface has no write methods, so the
  dashboard cannot edit financial records.
- **Role-aware:** the mock (and the real API) return `null` for sections a role
  may not see. Member -> My balance / contributions / arrears / next payout.
  Treasurer -> collection data, unmatched M-Pesa, arrears, 4 actions.
  Chairperson -> pending approvals. Auditor -> read-only ("View", never "Assign").
- **States:** skeleton while loading; error state with retry; pull-to-refresh
  keeps old data and shows a snackbar if the refresh fails; offline banner from
  `isOnlineProvider`; zero-count cards hidden, "all caught up" card when every
  visible card is zero; rotation hidden (not a merry-go-round) or "No active
  rotation" empty state.
- **Try each role:** debug builds only: More tab -> "View as <role>".
- **Navigation:** go_router with a 5-tab `StatefulShellRoute` (Home, Members,
  Money, Loans, More). Every route the dashboard links to exists as a
  placeholder (`core/router/app_router.dart`).

### Mocked vs real
| Mocked | Real |
|---|---|
| Dashboard data, session/role, sync-queue counts (always 0) | Theme, widgets, routing, connectivity (connectivity_plus), pull-to-refresh/error logic |

### Behaviour notes
- `StatusBadge.pending` is now amber (warning), per the Home spec; sync
  "pending" stays blue.
- The app bar title caps text scale at 1.5x so it can't overflow; all other
  content scales to 2.0x.
- Connectivity means a network interface is up, not that the server is reachable.