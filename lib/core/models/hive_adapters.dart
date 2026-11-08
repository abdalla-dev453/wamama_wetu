import 'package:hive/hive.dart';
import 'group.dart';
import 'member.dart';
import 'contribution.dart';
import 'mpesa_payment.dart';
import 'rotation.dart';
import 'audit_entry.dart';
import 'group_health_score.dart';
import 'loan.dart';
import 'fine.dart';

class GroupAdapter extends TypeAdapter<Group> {
  @override
  final int typeId = 0;

  @override
  Group read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Group(
      id: fields[0] as String,
      name: fields[1] as String,
      code: fields[2] as String,
      description: fields[3] as String?,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
      isActive: fields[6] as bool,
      currency: fields[7] as String,
      totalContributions: fields[8] as double,
      totalPayouts: fields[9] as double,
      currentPotBalance: fields[10] as double,
      paybillNumber: fields[11] as String?,
      memberCount: fields[12] as int,
      chairpersonId: fields[13] as String?,
      treasurerId: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Group obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.currency)
      ..writeByte(8)
      ..write(obj.totalContributions)
      ..writeByte(9)
      ..write(obj.totalPayouts)
      ..writeByte(10)
      ..write(obj.currentPotBalance)
      ..writeByte(11)
      ..write(obj.paybillNumber)
      ..writeByte(12)
      ..write(obj.memberCount)
      ..writeByte(13)
      ..write(obj.chairpersonId)
      ..writeByte(14)
      ..write(obj.treasurerId);
  }
}

class MemberAdapter extends TypeAdapter<Member> {
  @override
  final int typeId = 1;

  @override
  Member read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Member(
      id: fields[0] as String,
      groupId: fields[1] as String,
      memberNumber: fields[2] as String,
      fullName: fields[3] as String,
      phoneNumber: fields[4] as String,
      idNumber: fields[5] as String?,
      joinedAt: fields[6] as DateTime,
      isActive: fields[7] as bool,
      totalContributed: fields[8] as double,
      totalReceived: fields[9] as double,
      outstandingBalance: fields[10] as double,
      isChairperson: fields[11] as bool,
      isTreasurer: fields[12] as bool,
      email: fields[13] as String?,
      nextOfKin: fields[14] as String?,
      nextOfKinPhone: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Member obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.groupId)
      ..writeByte(2)
      ..write(obj.memberNumber)
      ..writeByte(3)
      ..write(obj.fullName)
      ..writeByte(4)
      ..write(obj.phoneNumber)
      ..writeByte(5)
      ..write(obj.idNumber)
      ..writeByte(6)
      ..write(obj.joinedAt)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.totalContributed)
      ..writeByte(9)
      ..write(obj.totalReceived)
      ..writeByte(10)
      ..write(obj.outstandingBalance)
      ..writeByte(11)
      ..write(obj.isChairperson)
      ..writeByte(12)
      ..write(obj.isTreasurer)
      ..writeByte(13)
      ..write(obj.email)
      ..writeByte(14)
      ..write(obj.nextOfKin)
      ..writeByte(15)
      ..write(obj.nextOfKinPhone);
  }
}

class ContributionAdapter extends TypeAdapter<Contribution> {
  @override
  final int typeId = 2;

  @override
  Contribution read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Contribution(
      id: fields[0] as String,
      groupId: fields[1] as String,
      memberId: fields[2] as String,
      amount: fields[3] as double,
      date: fields[4] as DateTime,
      type: _parseType(fields[5] as String),
      cycleId: fields[6] as String?,
      potId: fields[7] as String?,
      mpesaReceiptCode: fields[8] as String?,
      reference: fields[9] as String?,
      isCash: fields[10] as bool,
      recordedBy: fields[11] as String?,
      createdAt: fields[12] as DateTime,
      isReconciled: fields[13] as bool,
      reconciliationId: fields[14] as String?,
    );
  }

  static ContributionType _parseType(String value) {
    switch (value) {
      case 'weekly':
        return ContributionType.weekly;
      case 'monthly':
        return ContributionType.monthly;
      default:
        return ContributionType.oneOff;
    }
  }

  @override
  void write(BinaryWriter writer, Contribution obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.groupId)
      ..writeByte(2)
      ..write(obj.memberId)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.type.value)
      ..writeByte(6)
      ..write(obj.cycleId)
      ..writeByte(7)
      ..write(obj.potId)
      ..writeByte(8)
      ..write(obj.mpesaReceiptCode)
      ..writeByte(9)
      ..write(obj.reference)
      ..writeByte(10)
      ..write(obj.isCash)
      ..writeByte(11)
      ..write(obj.recordedBy)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.isReconciled)
      ..writeByte(14)
      ..write(obj.reconciliationId);
  }
}

class MpesaPaymentAdapter extends TypeAdapter<MpesaPayment> {
  @override
  final int typeId = 3;

  @override
  MpesaPayment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return MpesaPayment(
      id: fields[0] as String,
      groupId: fields[1] as String,
      phoneNumber: fields[2] as String,
      amount: fields[3] as double,
      transactionDate: fields[4] as DateTime,
      mpesaReceiptCode: fields[5] as String,
      reference: fields[6] as String,
      status: _parseStatus(fields[7] as String),
      matchedMemberId: fields[8] as String?,
      matchedContributionId: fields[9] as String?,
      allocatedAmount: fields[10] as double,
      remainingAmount: fields[11] as double,
      unmatchedReason: fields[12] as String?,
      requiresTreasurerReview: fields[13] as bool,
      assignedBy: fields[14] as String?,
      assignmentReason: fields[15] as String?,
      assignedAt: fields[16] as DateTime?,
      approvedBy: fields[17] as String?,
      approvedAt: fields[18] as DateTime?,
      createdAt: fields[19] as DateTime,
      updatedAt: fields[20] as DateTime,
    );
  }

  static MpesaPaymentStatus _parseStatus(String value) {
    switch (value) {
      case 'received':
        return MpesaPaymentStatus.received;
      case 'validating':
        return MpesaPaymentStatus.validating;
      case 'matched':
        return MpesaPaymentStatus.matched;
      case 'unmatched':
        return MpesaPaymentStatus.unmatched;
      case 'allocated':
        return MpesaPaymentStatus.allocated;
      case 'posted':
        return MpesaPaymentStatus.posted;
      case 'reversed':
        return MpesaPaymentStatus.reversed;
      default:
        return MpesaPaymentStatus.received;
    }
  }

  @override
  void write(BinaryWriter writer, MpesaPayment obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.groupId)
      ..writeByte(2)
      ..write(obj.phoneNumber)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.transactionDate)
      ..writeByte(5)
      ..write(obj.mpesaReceiptCode)
      ..writeByte(6)
      ..write(obj.reference)
      ..writeByte(7)
      ..write(obj.status.value)
      ..writeByte(8)
      ..write(obj.matchedMemberId)
      ..writeByte(9)
      ..write(obj.matchedContributionId)
      ..writeByte(10)
      ..write(obj.allocatedAmount)
      ..writeByte(11)
      ..write(obj.remainingAmount)
      ..writeByte(12)
      ..write(obj.unmatchedReason)
      ..writeByte(13)
      ..write(obj.requiresTreasurerReview)
      ..writeByte(14)
      ..write(obj.assignedBy)
      ..writeByte(15)
      ..write(obj.assignmentReason)
      ..writeByte(16)
      ..write(obj.assignedAt)
      ..writeByte(17)
      ..write(obj.approvedBy)
      ..writeByte(18)
      ..write(obj.approvedAt)
      ..writeByte(19)
      ..write(obj.createdAt)
      ..writeByte(20)
      ..write(obj.updatedAt);
  }
}

class RotationEntryAdapter extends TypeAdapter<RotationEntry> {
  @override
  final int typeId = 4;

  @override
  RotationEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return RotationEntry(
      id: fields[0] as String,
      groupId: fields[1] as String,
      memberId: fields[2] as String,
      position: fields[3] as int,
      payoutDate: fields[4] as DateTime,
      potAmount: fields[5] as double,
      isPaidOut: fields[6] as bool,
      paidOutAt: fields[7] as DateTime?,
      orderType: _parseOrderType(fields[8] as String),
      swappedFromMemberId: fields[9] as String?,
      swappedToMemberId: fields[10] as String?,
      postponementReason: fields[11] as String?,
      approvedBy: fields[12] as String?,
      createdAt: fields[13] as DateTime,
    );
  }

  static RotationOrderType _parseOrderType(String value) {
    switch (value) {
      case 'ballot':
        return RotationOrderType.ballot;
      case 'swap':
        return RotationOrderType.swap;
      case 'postponement':
        return RotationOrderType.postponement;
      default:
        return RotationOrderType.manual;
    }
  }

  @override
  void write(BinaryWriter writer, RotationEntry obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.groupId)
      ..writeByte(2)
      ..write(obj.memberId)
      ..writeByte(3)
      ..write(obj.position)
      ..writeByte(4)
      ..write(obj.payoutDate)
      ..writeByte(5)
      ..write(obj.potAmount)
      ..writeByte(6)
      ..write(obj.isPaidOut)
      ..writeByte(7)
      ..write(obj.paidOutAt)
      ..writeByte(8)
      ..write(obj.orderType.toString().split('.').last)
      ..writeByte(9)
      ..write(obj.swappedFromMemberId)
      ..writeByte(10)
      ..write(obj.swappedToMemberId)
      ..writeByte(11)
      ..write(obj.postponementReason)
      ..writeByte(12)
      ..write(obj.approvedBy)
      ..writeByte(13)
      ..write(obj.createdAt);
  }
}

class AuditEntryAdapter extends TypeAdapter<AuditEntry> {
  @override
  final int typeId = 5;

  @override
  AuditEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return AuditEntry(
      id: fields[0] as String,
      groupId: fields[1] as String,
      actorId: fields[2] as String,
      approverId: fields[3] as String?,
      action: _parseAction(fields[4] as String),
      timestamp: fields[5] as DateTime,
      beforeValues: fields[6] as Map<String, dynamic>?,
      afterValues: fields[7] as Map<String, dynamic>?,
      reason: fields[8] as String?,
      deviceId: fields[9] as String?,
      sessionId: fields[10] as String?,
      ipAddress: fields[11] as String?,
      targetType: fields[12] as String?,
      targetId: fields[13] as String?,
    );
  }

  static AuditAction _parseAction(String value) {
    switch (value) {
      case 'contributionRecorded':
        return AuditAction.contributionRecorded;
      case 'contributionReversed':
        return AuditAction.contributionReversed;
      case 'paymentReconciled':
        return AuditAction.paymentReconciled;
      case 'paymentAssigned':
        return AuditAction.paymentAssigned;
      case 'paymentReversed':
        return AuditAction.paymentReversed;
      case 'memberAdded':
        return AuditAction.memberAdded;
      case 'memberUpdated':
        return AuditAction.memberUpdated;
      case 'memberRemoved':
        return AuditAction.memberRemoved;
      case 'rotationPayout':
        return AuditAction.rotationPayout;
      case 'rotationSwap':
        return AuditAction.rotationSwap;
      case 'rotationPostponement':
        return AuditAction.rotationPostponement;
      case 'groupCreated':
        return AuditAction.groupCreated;
      case 'groupUpdated':
        return AuditAction.groupUpdated;
      case 'loanIssued':
        return AuditAction.loanIssued;
      case 'loanRepaid':
        return AuditAction.loanRepaid;
      case 'fineIssued':
        return AuditAction.fineIssued;
      case 'finePaid':
        return AuditAction.finePaid;
      case 'settingsChanged':
        return AuditAction.settingsChanged;
      case 'dataImported':
        return AuditAction.dataImported;
      default:
        return AuditAction.settingsChanged;
    }
  }

  @override
  void write(BinaryWriter writer, AuditEntry obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.groupId)
      ..writeByte(2)
      ..write(obj.actorId)
      ..writeByte(3)
      ..write(obj.approverId)
      ..writeByte(4)
      ..write(obj.action.value)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.beforeValues)
      ..writeByte(7)
      ..write(obj.afterValues)
      ..writeByte(8)
      ..write(obj.reason)
      ..writeByte(9)
      ..write(obj.deviceId)
      ..writeByte(10)
      ..write(obj.sessionId)
      ..writeByte(11)
      ..write(obj.ipAddress)
      ..writeByte(12)
      ..write(obj.targetType)
      ..writeByte(13)
      ..write(obj.targetId);
  }
}

class GroupHealthScoreAdapter extends TypeAdapter<GroupHealthScore> {
  @override
  final int typeId = 6;

  @override
  GroupHealthScore read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return GroupHealthScore(
      id: fields[0] as String,
      groupId: fields[1] as String,
      score: fields[2] as int,
      collectionRate: fields[3] as double,
      arrearsRate: fields[4] as double,
      loanRepaymentRate: fields[5] as double,
      meetingAttendanceRate: fields[6] as double,
      unmatchedPaymentsCount: fields[7] as int,
      recommendedActions: (fields[8] as List<dynamic>?)?.cast<String>() ?? [],
      calculatedAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GroupHealthScore obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.groupId)
      ..writeByte(2)
      ..write(obj.score)
      ..writeByte(3)
      ..write(obj.collectionRate)
      ..writeByte(4)
      ..write(obj.arrearsRate)
      ..writeByte(5)
      ..write(obj.loanRepaymentRate)
      ..writeByte(6)
      ..write(obj.meetingAttendanceRate)
      ..writeByte(7)
      ..write(obj.unmatchedPaymentsCount)
      ..writeByte(8)
      ..write(obj.recommendedActions)
      ..writeByte(9)
      ..write(obj.calculatedAt);
  }
}

class LoanAdapter extends TypeAdapter<Loan> {
  @override
  final int typeId = 7;

  @override
  Loan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Loan(
      id: fields[0] as String,
      groupId: fields[1] as String,
      memberId: fields[2] as String,
      principalAmount: fields[3] as double,
      interestRate: fields[4] as double,
      totalAmount: fields[5] as double,
      amountRepaid: fields[6] as double,
      status: _parseStatus(fields[7] as String),
      issuedAt: fields[8] as DateTime,
      dueDate: fields[9] as DateTime?,
      repaidAt: fields[10] as DateTime?,
      purpose: fields[11] as String?,
      guarantorIds: (fields[12] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  static LoanStatus _parseStatus(String value) {
    switch (value) {
      case 'active':
        return LoanStatus.active;
      case 'repaid':
        return LoanStatus.repaid;
      case 'defaulted':
        return LoanStatus.defaulted;
      case 'writtenOff':
        return LoanStatus.writtenOff;
      default:
        return LoanStatus.active;
    }
  }

  @override
  void write(BinaryWriter writer, Loan obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.groupId)
      ..writeByte(2)
      ..write(obj.memberId)
      ..writeByte(3)
      ..write(obj.principalAmount)
      ..writeByte(4)
      ..write(obj.interestRate)
      ..writeByte(5)
      ..write(obj.totalAmount)
      ..writeByte(6)
      ..write(obj.amountRepaid)
      ..writeByte(7)
      ..write(obj.status.toString().split('.').last)
      ..writeByte(8)
      ..write(obj.issuedAt)
      ..writeByte(9)
      ..write(obj.dueDate)
      ..writeByte(10)
      ..write(obj.repaidAt)
      ..writeByte(11)
      ..write(obj.purpose)
      ..writeByte(12)
      ..write(obj.guarantorIds);
  }
}

class FineAdapter extends TypeAdapter<Fine> {
  @override
  final int typeId = 8;

  @override
  Fine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Fine(
      id: fields[0] as String,
      groupId: fields[1] as String,
      memberId: fields[2] as String,
      amount: fields[3] as double,
      reason: fields[4] as String,
      status: _parseStatus(fields[5] as String),
      issuedAt: fields[6] as DateTime,
      paidAt: fields[7] as DateTime?,
      recordedBy: fields[8] as String?,
    );
  }

  static FineStatus _parseStatus(String value) {
    switch (value) {
      case 'active':
        return FineStatus.active;
      case 'paid':
        return FineStatus.paid;
      case 'waived':
        return FineStatus.waived;
      default:
        return FineStatus.active;
    }
  }

  @override
  void write(BinaryWriter writer, Fine obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.groupId)
      ..writeByte(2)
      ..write(obj.memberId)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.reason)
      ..writeByte(5)
      ..write(obj.status.toString().split('.').last)
      ..writeByte(6)
      ..write(obj.issuedAt)
      ..writeByte(7)
      ..write(obj.paidAt)
      ..writeByte(8)
      ..write(obj.recordedBy);
  }
}