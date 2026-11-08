import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/models/group.dart';
import 'core/models/member.dart';
import 'core/models/contribution.dart';
import 'core/models/mpesa_payment.dart';
import 'core/models/rotation.dart';
import 'core/models/audit_entry.dart';
import 'core/models/group_health_score.dart';
import 'core/models/loan.dart';
import 'core/models/fine.dart';
import 'core/models/hive_adapters.dart';
import 'core/providers/app_providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register all Hive adapters
  Hive.registerAdapter(GroupAdapter());
  Hive.registerAdapter(MemberAdapter());
  Hive.registerAdapter(ContributionAdapter());
  Hive.registerAdapter(MpesaPaymentAdapter());
  Hive.registerAdapter(RotationEntryAdapter());
  Hive.registerAdapter(AuditEntryAdapter());
  Hive.registerAdapter(GroupHealthScoreAdapter());
  Hive.registerAdapter(LoanAdapter());
  Hive.registerAdapter(FineAdapter());

  // Open all boxes
  await Hive.openBox<Group>('groups');
  await Hive.openBox<Member>('members');
  await Hive.openBox<Contribution>('contributions');
  await Hive.openBox<MpesaPayment>('mpesa_payments');
  await Hive.openBox<RotationEntry>('rotations');
  await Hive.openBox<AuditEntry>('audit_entries');
  await Hive.openBox<GroupHealthScore>('health_scores');
  await Hive.openBox<Loan>('loans');
  await Hive.openBox<Fine>('fines');

  final hiveService = HiveService()
    ..groupBox = Hive.box<Group>('groups')
    ..memberBox = Hive.box<Member>('members')
    ..contributionBox = Hive.box<Contribution>('contributions')
    ..mpesaPaymentBox = Hive.box<MpesaPayment>('mpesa_payments')
    ..rotationBox = Hive.box<RotationEntry>('rotations')
    ..auditBox = Hive.box<AuditEntry>('audit_entries')
    ..healthScoreBox = Hive.box<GroupHealthScore>('health_scores')
    ..loanBox = Hive.box<Loan>('loans')
    ..fineBox = Hive.box<Fine>('fines');

  runApp(ProviderScope(
    overrides: [hiveServiceProvider.overrideWithValue(hiveService)],
    child: const ChamifyApp(),
  ));
}

class ChamifyApp extends ConsumerWidget {
  const ChamifyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Chamify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}