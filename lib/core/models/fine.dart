import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';


final _uuid = Uuid();

enum FineStatus { active, paid, waived }

@HiveType(typeId: 8)
class Fine extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String groupId;

  @HiveField(2)
  String memberId;

  @HiveField(3)
  double amount;

  @HiveField(4)
  String reason;

  @HiveField(5)
  FineStatus status;

  @HiveField(6)
  DateTime issuedAt;

  @HiveField(7)
  DateTime? paidAt;

  @HiveField(8)
  String? recordedBy;

  Fine({
    String? id,
    required this.groupId,
    required this.memberId,
    required this.amount,
    required this.reason,
    this.status = FineStatus.active,
    DateTime? issuedAt,
    this.paidAt,
    this.recordedBy,
  }) : id = id ?? _uuid.v4(),
       issuedAt = issuedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'groupId': groupId,
        'memberId': memberId,
        'amount': amount,
        'reason': reason,
        'status': status.toString().split('.').last,
        'issuedAt': issuedAt.toIso8601String(),
        'paidAt': paidAt?.toIso8601String(),
        'recordedBy': recordedBy,
      };

  factory Fine.fromJson(Map<String, dynamic> json) => Fine(
        id: json['id'] as String,
        groupId: json['groupId'] as String,
        memberId: json['memberId'] as String,
        amount: (json['amount'] as num).toDouble(),
        reason: json['reason'] as String,
        status: _parseStatus(json['status'] as String),
        issuedAt: DateTime.parse(json['issuedAt'] as String),
        paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
        recordedBy: json['recordedBy'] as String?,
      );

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
}