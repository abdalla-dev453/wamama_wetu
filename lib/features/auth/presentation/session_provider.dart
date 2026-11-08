import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_sessions.dart';
import '../domain/app_role.dart';
import '../domain/app_session.dart';

/// Current signed-in session. MOCK default: the Treasurer of Umoja.
/// Changing the role (dev switcher on the More tab) rebuilds role-aware
/// screens such as Home.
final sessionProvider = StateProvider<AppSession>(
  (ref) => MockSessions.treasurer,
);

final currentRoleProvider = Provider<AppRole>(
  (ref) => ref.watch(sessionProvider).role,
);
