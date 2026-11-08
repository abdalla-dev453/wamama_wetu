import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/group.dart';
import '../models/member.dart';
import '../models/contribution.dart';
import '../models/mpesa_payment.dart';
import '../models/rotation.dart';
import '../models/audit_entry.dart';
import '../models/group_health_score.dart';
import '../models/loan.dart';
import '../models/fine.dart';
import '../models/hive_adapters.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  final service = HiveService();
  service.initSync();
  return service;
});

class HiveService {
  Box<Group>? groupBox;
  Box<Member>? memberBox;
  Box<Contribution>? contributionBox;
  Box<MpesaPayment>? mpesaPaymentBox;
  Box<RotationEntry>? rotationBox;
  Box<AuditEntry>? auditBox;
  Box<GroupHealthScore>? healthScoreBox;
  Box<Loan>? loanBox;
  Box<Fine>? fineBox;

  void initSync() {
    Hive.registerAdapter(GroupAdapter());
    Hive.registerAdapter(MemberAdapter());
    Hive.registerAdapter(ContributionAdapter());
    Hive.registerAdapter(MpesaPaymentAdapter());
    Hive.registerAdapter(RotationEntryAdapter());
    Hive.registerAdapter(AuditEntryAdapter());
    Hive.registerAdapter(GroupHealthScoreAdapter());
    Hive.registerAdapter(LoanAdapter());
    Hive.registerAdapter(FineAdapter());
  }

  Future<void> init() async {
    initSync();
    groupBox = await Hive.openBox<Group>('groups');
    memberBox = await Hive.openBox<Member>('members');
    contributionBox = await Hive.openBox<Contribution>('contributions');
    mpesaPaymentBox = await Hive.openBox<MpesaPayment>('mpesa_payments');
    rotationBox = await Hive.openBox<RotationEntry>('rotations');
    auditBox = await Hive.openBox<AuditEntry>('audit_entries');
    healthScoreBox = await Hive.openBox<GroupHealthScore>('health_scores');
    loanBox = await Hive.openBox<Loan>('loans');
    fineBox = await Hive.openBox<Fine>('fines');
  }

  Box<Group> get groups => groupBox!;
  Box<Member> get members => memberBox!;
  Box<Contribution> get contributions => contributionBox!;
  Box<MpesaPayment> get mpesaPayments => mpesaPaymentBox!;
  Box<RotationEntry> get rotations => rotationBox!;
  Box<AuditEntry> get auditEntries => auditBox!;
  Box<GroupHealthScore> get healthScores => healthScoreBox!;
  Box<Loan> get loans => loanBox!;
  Box<Fine> get fines => fineBox!;
}

// Auth / session
final currentUserIdProvider = StateProvider<String?>((ref) => null);
final currentGroupIdProvider = StateProvider<String?>((ref) => null);

// Group list
final groupsProvider = StateNotifierProvider<GroupsNotifier, AsyncValue<List<Group>>>((ref) {
  return GroupsNotifier(ref.read(hiveServiceProvider));
});

class GroupsNotifier extends StateNotifier<AsyncValue<List<Group>>> {
  final HiveService _hive;

  GroupsNotifier(this._hive) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final groups = _hive.groups.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      state = AsyncValue.data(groups);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> add(Group group) async {
    await _hive.groups.add(group);
    await load();
  }

  Future<void> update(Group group) async {
    await group.save();
    await load();
  }

  Future<void> delete(String id) async {
    final box = _hive.groups;
    final key = box.keys.firstWhere((k) => box.get(k)?.id == id, orElse: () => null);
    if (key != null) await box.delete(key);
    await load();
  }
}

// Members
final membersProvider = StateNotifierProvider<MembersNotifier, AsyncValue<List<Member>>>((ref) {
  final groupId = ref.watch(currentGroupIdProvider) ?? '';
  return MembersNotifier(ref.read(hiveServiceProvider), groupId);
});

class MembersNotifier extends StateNotifier<AsyncValue<List<Member>>> {
  final HiveService _hive;
  final String _groupId;

  MembersNotifier(this._hive, this._groupId) : super(const AsyncValue.data([])) {
    if (_groupId.isNotEmpty) load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final members = _hive.members.values
          .where((m) => m.groupId == _groupId && m.isActive)
          .toList()
        ..sort((a, b) => a.memberNumber.compareTo(b.memberNumber));
      state = AsyncValue.data(members);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> add(Member member) async {
    await _hive.members.add(member);
    await load();
  }

  Future<void> update(Member member) async {
    await member.save();
    await load();
  }
}

// M-PESA Payments
final mpesaPaymentsProvider = StateNotifierProvider<MpesaPaymentsNotifier, AsyncValue<List<MpesaPayment>>>((ref) {
  final groupId = ref.watch(currentGroupIdProvider) ?? '';
  return MpesaPaymentsNotifier(ref.read(hiveServiceProvider), groupId);
});

class MpesaPaymentsNotifier extends StateNotifier<AsyncValue<List<MpesaPayment>>> {
  final HiveService _hive;
  final String _groupId;

  MpesaPaymentsNotifier(this._hive, this._groupId) : super(const AsyncValue.data([])) {
    if (_groupId.isNotEmpty) load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final payments = _hive.mpesaPayments.values
          .where((p) => p.groupId == _groupId)
          .toList()
        ..sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
      state = AsyncValue.data(payments);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> add(MpesaPayment payment) async {
    await _hive.mpesaPayments.add(payment);
    await load();
  }

  Future<void> update(MpesaPayment payment) async {
    await payment.save();
    await load();
  }

  List<MpesaPayment> get unmatched => state.value?.where((p) => p.status == MpesaPaymentStatus.unmatched).toList() ?? [];
  List<MpesaPayment> get pendingReview => state.value?.where((p) => p.requiresTreasurerReview).toList() ?? [];
}

// Contributions
final contributionsProvider = StateNotifierProvider<ContributionsNotifier, AsyncValue<List<Contribution>>>((ref) {
  final groupId = ref.watch(currentGroupIdProvider) ?? '';
  return ContributionsNotifier(ref.read(hiveServiceProvider), groupId);
});

class ContributionsNotifier extends StateNotifier<AsyncValue<List<Contribution>>> {
  final HiveService _hive;
  final String _groupId;

  ContributionsNotifier(this._hive, this._groupId) : super(const AsyncValue.data([])) {
    if (_groupId.isNotEmpty) load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final contributions = _hive.contributions.values
          .where((c) => c.groupId == _groupId)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      state = AsyncValue.data(contributions);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> add(Contribution contribution) async {
    await _hive.contributions.add(contribution);
    await load();
  }
}

// Rotation entries
final rotationProvider = StateNotifierProvider<RotationNotifier, AsyncValue<List<RotationEntry>>>((ref) {
  final groupId = ref.watch(currentGroupIdProvider) ?? '';
  return RotationNotifier(ref.read(hiveServiceProvider), groupId);
});

class RotationNotifier extends StateNotifier<AsyncValue<List<RotationEntry>>> {
  final HiveService _hive;
  final String _groupId;

  RotationNotifier(this._hive, this._groupId) : super(const AsyncValue.data([])) {
    if (_groupId.isNotEmpty) load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final entries = _hive.rotations.values
          .where((r) => r.groupId == _groupId)
          .toList()
        ..sort((a, b) => a.position.compareTo(b.position));
      state = AsyncValue.data(entries);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> add(RotationEntry entry) async {
    await _hive.rotations.add(entry);
    await load();
  }
}

// Audit entries
final auditEntriesProvider = StateNotifierProvider<AuditNotifier, AsyncValue<List<AuditEntry>>>((ref) {
  final groupId = ref.watch(currentGroupIdProvider) ?? '';
  return AuditNotifier(ref.read(hiveServiceProvider), groupId);
});

class AuditNotifier extends StateNotifier<AsyncValue<List<AuditEntry>>> {
  final HiveService _hive;
  final String _groupId;

  AuditNotifier(this._hive, this._groupId) : super(const AsyncValue.data([])) {
    if (_groupId.isNotEmpty) load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final entries = _hive.auditEntries.values
          .where((a) => a.groupId == _groupId)
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      state = AsyncValue.data(entries);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> add(AuditEntry entry) async {
    await _hive.auditEntries.add(entry);
    await load();
  }
}

// Health score
final healthScoreProvider = StateNotifierProvider<HealthScoreNotifier, AsyncValue<GroupHealthScore?>>((ref) {
  final groupId = ref.watch(currentGroupIdProvider) ?? '';
  return HealthScoreNotifier(ref.read(hiveServiceProvider), groupId);
});

class HealthScoreNotifier extends StateNotifier<AsyncValue<GroupHealthScore?>> {
  final HiveService _hive;
  final String _groupId;

  HealthScoreNotifier(this._hive, this._groupId) : super(const AsyncValue.data(null)) {
    if (_groupId.isNotEmpty) load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final scores = _hive.healthScores.values.where((s) => s.groupId == _groupId).toList()
        ..sort((a, b) => b.calculatedAt.compareTo(a.calculatedAt));
      state = AsyncValue.data(scores.isNotEmpty ? scores.first : null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> save(GroupHealthScore score) async {
    await _hive.healthScores.add(score);
    await load();
  }
}

// Loans
final loansProvider = StateNotifierProvider<LoansNotifier, AsyncValue<List<Loan>>>((ref) {
  final groupId = ref.watch(currentGroupIdProvider) ?? '';
  return LoansNotifier(ref.read(hiveServiceProvider), groupId);
});

class LoansNotifier extends StateNotifier<AsyncValue<List<Loan>>> {
  final HiveService _hive;
  final String _groupId;

  LoansNotifier(this._hive, this._groupId) : super(const AsyncValue.data([])) {
    if (_groupId.isNotEmpty) load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final loans = _hive.loans.values.where((l) => l.groupId == _groupId).toList()
        ..sort((a, b) => b.issuedAt.compareTo(a.issuedAt));
      state = AsyncValue.data(loans);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> add(Loan loan) async {
    await _hive.loans.add(loan);
    await load();
  }
}

// Fines
final finesProvider = StateNotifierProvider<FinesNotifier, AsyncValue<List<Fine>>>((ref) {
  final groupId = ref.watch(currentGroupIdProvider) ?? '';
  return FinesNotifier(ref.read(hiveServiceProvider), groupId);
});

class FinesNotifier extends StateNotifier<AsyncValue<List<Fine>>> {
  final HiveService _hive;
  final String _groupId;

  FinesNotifier(this._hive, this._groupId) : super(const AsyncValue.data([])) {
    if (_groupId.isNotEmpty) load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final fines = _hive.fines.values.where((f) => f.groupId == _groupId).toList()
        ..sort((a, b) => b.issuedAt.compareTo(a.issuedAt));
      state = AsyncValue.data(fines);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> add(Fine fine) async {
    await _hive.fines.add(fine);
    await load();
  }
}