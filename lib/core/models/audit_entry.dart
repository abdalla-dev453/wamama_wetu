import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';


final _uuid = Uuid();

enum AuditAction {
  contributionRecorded,
  contributionReversed,
  paymentReconciled,
  paymentAssigned,
  paymentReversed,
  memberAdded,
  memberUpdated,
  memberRemoved,
  rotationPayout,
  rotationSwap,
  rotationPostponement,
  groupCreated,
  groupUpdated,
  loanIssued,
  loanRepaid,
  fineIssued,
  finePaid,
  settingsChanged,
  dataImported,
}

extension AuditActionExtension on AuditAction {
  String get value => toString().split('.').last;

  String get label {
    switch (this) {
      case AuditAction.contributionRecorded:
        return 'Contribution Recorded';
      case AuditAction.contributionReversed:
        return 'Contribution Reversed';
      case AuditAction.paymentReconciled:
        return 'Payment Reconciled';
      case AuditAction.paymentAssigned:
        return 'Payment Assigned';
      case AuditAction.paymentReversed:
        return 'Payment Reversed';
      case AuditAction.memberAdded:
        return 'Member Added';
      case AuditAction.memberUpdated:
        return 'Member Updated';
      case AuditAction.memberRemoved:
        return 'Member Removed';
      case AuditAction.rotationPayout:
        return 'Rotation Payout';
      case AuditAction.rotationSwap:
        return 'Rotation Swap';
      case AuditAction.rotationPostponement:
        return 'Rotation Postponement';
      case AuditAction.groupCreated:
        return 'Group Created';
      case AuditAction.groupUpdated:
        return 'Group Updated';
      case AuditAction.loanIssued:
        return 'Loan Issued';
      case AuditAction.loanRepaid:
        return 'Loan Repaid';
      case AuditAction.fineIssued:
        return 'Fine Issued';
      case AuditAction.finePaid:
        return 'Fine Paid';
      case AuditAction.settingsChanged:
        return 'Settings Changed';
      case AuditAction.dataImported:
        return 'Data Imported';
    }
  }
}

@HiveType(typeId: 5)
class AuditEntry extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String groupId;

  @HiveField(2)
  String actorId; // Who performed the action

  @HiveField(3)
  String? approverId; // Who approved (for sensitive actions)

  @HiveField(4)
  AuditAction action;

  @HiveField(5)
  DateTime timestamp;

  @HiveField(6)
  Map<String, dynamic>? beforeValues;

  @HiveField(7)
  Map<String, dynamic>? afterValues;

  @HiveField(8)
  String? reason;

  @HiveField(9)
  String? deviceId;

  @HiveField(10)
  String? sessionId;

  @HiveField(11)
  String? ipAddress;

  @HiveField(12)
  String? targetType; // e.g., "member", "contribution", "payment"

  @HiveField(13)
  String? targetId;

  AuditEntry({
    String? id,
    required this.groupId,
    required this.actorId,
    this.approverId,
    required this.action,
    DateTime? timestamp,
    this.beforeValues,
    this.afterValues,
    this.reason,
    this.deviceId,
    this.sessionId,
    this.ipAddress,
    this.targetType,
    this.targetId,
  }) : id = id ?? _uuid.v4(),
       timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'groupId': groupId,
        'actorId': actorId,
        'approverId': approverId,
        'action': action.value,
        'timestamp': timestamp.toIso8601String(),
        'beforeValues': beforeValues,
        'afterValues': afterValues,
        'reason': reason,
        'deviceId': deviceId,
        'sessionId': sessionId,
        'ipAddress': ipAddress,
        'targetType': targetType,
        'targetId': targetId,
      };

  factory AuditEntry.fromJson(Map<String, dynamic> json) => AuditEntry(
        id: json['id'] as String,
        groupId: json['groupId'] as String,
        actorId: json['actorId'] as String,
        approverId: json['approverId'] as String?,
        action: _parseAction(json['action'] as String),
        timestamp: DateTime.parse(json['timestamp'] as String),
        beforeValues: json['beforeValues'] as Map<String, dynamic>?,
        afterValues: json['afterValues'] as Map<String, dynamic>?,
        reason: json['reason'] as String?,
        deviceId: json['deviceId'] as String?,
        sessionId: json['sessionId'] as String?,
        ipAddress: json['ipAddress'] as String?,
        targetType: json['targetType'] as String?,
        targetId: json['targetId'] as String?,
      );

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
}