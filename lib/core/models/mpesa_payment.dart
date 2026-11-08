import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';


final _uuid = Uuid();

enum MpesaPaymentStatus {
  received,
  validating,
  matched,
  unmatched,
  allocated,
  posted,
  reversed,
}

extension MpesaPaymentStatusExtension on MpesaPaymentStatus {
  String get value => toString().split('.').last;

  String get label {
    switch (this) {
      case MpesaPaymentStatus.received:
        return 'Received';
      case MpesaPaymentStatus.validating:
        return 'Validating';
      case MpesaPaymentStatus.matched:
        return 'Matched';
      case MpesaPaymentStatus.unmatched:
        return 'Unmatched';
      case MpesaPaymentStatus.allocated:
        return 'Allocated';
      case MpesaPaymentStatus.posted:
        return 'Posted';
      case MpesaPaymentStatus.reversed:
        return 'Reversed';
    }
  }

  Color get color {
    switch (this) {
      case MpesaPaymentStatus.received:
        return Colors.blue;
      case MpesaPaymentStatus.validating:
        return Colors.orange;
      case MpesaPaymentStatus.matched:
        return Colors.green;
      case MpesaPaymentStatus.unmatched:
        return Colors.red;
      case MpesaPaymentStatus.allocated:
        return Colors.teal;
      case MpesaPaymentStatus.posted:
        return Colors.green;
      case MpesaPaymentStatus.reversed:
        return Colors.grey;
    }
  }
}

@HiveType(typeId: 3)
class MpesaPayment extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String groupId;

  @HiveField(2)
  String phoneNumber;

  @HiveField(3)
  double amount;

  @HiveField(4)
  DateTime transactionDate;

  @HiveField(5)
  String mpesaReceiptCode;

  @HiveField(6)
  String reference; // GROUPCODE#MEMBERNO

  @HiveField(7)
  MpesaPaymentStatus status;

  @HiveField(8)
  String? matchedMemberId;

  @HiveField(9)
  String? matchedContributionId;

  @HiveField(10)
  double allocatedAmount;

  @HiveField(11)
  double remainingAmount;

  @HiveField(12)
  String? unmatchedReason;

  @HiveField(13)
  bool requiresTreasurerReview;

  @HiveField(14)
  String? assignedBy; // Treasurer who assigned

  @HiveField(15)
  String? assignmentReason;

  @HiveField(16)
  DateTime? assignedAt;

  @HiveField(17)
  String? approvedBy;

  @HiveField(18)
  DateTime? approvedAt;

  @HiveField(19)
  DateTime createdAt;

  @HiveField(20)
  DateTime updatedAt;

  MpesaPayment({
    String? id,
    required this.groupId,
    required this.phoneNumber,
    required this.amount,
    required this.transactionDate,
    required this.mpesaReceiptCode,
    required this.reference,
    this.status = MpesaPaymentStatus.received,
    this.matchedMemberId,
    this.matchedContributionId,
    this.allocatedAmount = 0.0,
    this.remainingAmount = 0.0,
    this.unmatchedReason,
    this.requiresTreasurerReview = true,
    this.assignedBy,
    this.assignmentReason,
    this.assignedAt,
    this.approvedBy,
    this.approvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? _uuid.v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'groupId': groupId,
        'phoneNumber': phoneNumber,
        'amount': amount,
        'transactionDate': transactionDate.toIso8601String(),
        'mpesaReceiptCode': mpesaReceiptCode,
        'reference': reference,
        'status': status.value,
        'matchedMemberId': matchedMemberId,
        'matchedContributionId': matchedContributionId,
        'allocatedAmount': allocatedAmount,
        'remainingAmount': remainingAmount,
        'unmatchedReason': unmatchedReason,
        'requiresTreasurerReview': requiresTreasurerReview,
        'assignedBy': assignedBy,
        'assignmentReason': assignmentReason,
        'assignedAt': assignedAt?.toIso8601String(),
        'approvedBy': approvedBy,
        'approvedAt': approvedAt?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory MpesaPayment.fromJson(Map<String, dynamic> json) => MpesaPayment(
        id: json['id'] as String,
        groupId: json['groupId'] as String,
        phoneNumber: json['phoneNumber'] as String,
        amount: (json['amount'] as num).toDouble(),
        transactionDate: DateTime.parse(json['transactionDate'] as String),
        mpesaReceiptCode: json['mpesaReceiptCode'] as String,
        reference: json['reference'] as String,
        status: _parseStatus(json['status'] as String),
        matchedMemberId: json['matchedMemberId'] as String?,
        matchedContributionId: json['matchedContributionId'] as String?,
        allocatedAmount: (json['allocatedAmount'] as num?)?.toDouble() ?? 0.0,
        remainingAmount: (json['remainingAmount'] as num?)?.toDouble() ?? 0.0,
        unmatchedReason: json['unmatchedReason'] as String?,
        requiresTreasurerReview: json['requiresTreasurerReview'] as bool? ?? true,
        assignedBy: json['assignedBy'] as String?,
        assignmentReason: json['assignmentReason'] as String?,
        assignedAt: json['assignedAt'] != null ? DateTime.parse(json['assignedAt']) : null,
        approvedBy: json['approvedBy'] as String?,
        approvedAt: json['approvedAt'] != null ? DateTime.parse(json['approvedAt']) : null,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

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
}