import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:chamify_app/features/home/presentation/screens/home_screen.dart';
import 'package:chamify_app/features/groups/presentation/screens/groups_screen.dart';
import 'package:chamify_app/features/members/presentation/screens/members_screen.dart';
import 'package:chamify_app/features/ledger/presentation/screens/ledger_screen.dart';
import 'package:chamify_app/features/mpesa/presentation/screens/reconciliation_screen.dart';
import 'package:chamify_app/features/rotation/presentation/screens/rotation_screen.dart';
import 'package:chamify_app/features/audit/presentation/screens/audit_screen.dart';
import 'package:chamify_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:chamify_app/features/collection/presentation/screens/collection_day_screen.dart';
import 'package:chamify_app/features/health/presentation/screens/health_score_screen.dart';
import 'package:chamify_app/features/csv_import/presentation/screens/csv_import_screen.dart';
import 'package:chamify_app/features/member_trust/presentation/screens/member_statement_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      ShellRoute(
        builder: (context, state, child) => ScaffoldWithShell(
          child: child,
          currentLocation: state.uri.path,
        ),
        routes: [
          GoRoute(path: '/', name: 'home', builder: (context, state) => const HomeScreen()),
          GoRoute(path: '/groups', name: 'groups', builder: (context, state) => const GroupsScreen()),
          GoRoute(path: '/members', name: 'members', builder: (context, state) => const MembersScreen()),
          GoRoute(path: '/ledger', name: 'ledger', builder: (context, state) => const LedgerScreen()),
          GoRoute(path: '/mpesa-reconciliation', name: 'mpesa-reconciliation', builder: (context, state) => const ReconciliationScreen()),
          GoRoute(path: '/rotation', name: 'rotation', builder: (context, state) => const RotationScreen()),
          GoRoute(path: '/audit', name: 'audit', builder: (context, state) => const AuditScreen()),
          GoRoute(path: '/collection-day', name: 'collection-day', builder: (context, state) => const CollectionDayScreen()),
          GoRoute(path: '/health-score', name: 'health-score', builder: (context, state) => const HealthScoreScreen()),
          GoRoute(path: '/csv-import', name: 'csv-import', builder: (context, state) => const CsvImportScreen()),
          GoRoute(path: '/member-statement', name: 'member-statement', builder: (context, state) => const MemberStatementScreen()),
          GoRoute(path: '/settings', name: 'settings', builder: (context, state) => const SettingsScreen()),
        ],
      ),
    ],
  );
}

class ScaffoldWithShell extends StatelessWidget {
  const ScaffoldWithShell({required this.child, required this.currentLocation, super.key});

  final Widget child;
  final String currentLocation;

  static const _destinations = [
    NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.group_outlined), label: 'Groups'),
    NavigationDestination(icon: Icon(Icons.people_outlined), label: 'Members'),
    NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Ledger'),
    NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), label: 'M-Pesa'),
    NavigationDestination(icon: Icon(Icons.refresh_outlined), label: 'Rotation'),
    NavigationDestination(icon: Icon(Icons.description_outlined), label: 'Audit'),
    NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;
    if (currentLocation.startsWith('/groups')) currentIndex = 1;
    if (currentLocation.startsWith('/members')) currentIndex = 2;
    if (currentLocation.startsWith('/ledger')) currentIndex = 3;
    if (currentLocation.startsWith('/mpesa')) currentIndex = 4;
    if (currentLocation.startsWith('/rotation')) currentIndex = 5;
    if (currentLocation.startsWith('/audit')) currentIndex = 6;
    if (currentLocation.startsWith('/settings')) currentIndex = 7;

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Stack(
          children: [
            child,
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: NavigationBar(
                destinations: _destinations,
                selectedIndex: currentIndex.clamp(0, _destinations.length - 1),
                onDestinationSelected: (index) {
                  switch (index) {
                    case 0:
                      context.go('/');
                      break;
                    case 1:
                      context.go('/groups');
                      break;
                    case 2:
                      context.go('/members');
                      break;
                    case 3:
                      context.go('/ledger');
                      break;
                    case 4:
                      context.go('/mpesa-reconciliation');
                      break;
                    case 5:
                      context.go('/rotation');
                      break;
                    case 6:
                      context.go('/audit');
                      break;
                    case 7:
                      context.go('/settings');
                      break;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}