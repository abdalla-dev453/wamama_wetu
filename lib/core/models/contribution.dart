import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';


final _uuid = Uuid();

enum ContributionType { weekly, monthly, oneOff }

extension ContributionTypeExtension on ContributionType {
  String get value => toString().split('.').last;
}

@HiveType(typeId: 2)
class Contribution extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String groupId;

  @HiveField(2)
  String memberId;

  @HiveField(3)
  double amount;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  ContributionType type;

  @HiveField(6)
  String? cycleId; // Contribution cycle reference

  @HiveField(7)
  String? potId; // Pot reference for rotation

  @HiveField(8)
  String? mpesaReceiptCode;

  @HiveField(9)
  String? reference; // M-PESA reference: GROUPCODE#MEMBERNO

  @HiveField(10)
  bool isCash;

  @HiveField(11)
  String? recordedBy; // Member ID who recorded (treasurer)

  @HiveField(12)
  DateTime createdAt;

  @HiveField(13)
  bool isReconciled;

  @HiveField(14)
  String? reconciliationId;

  Contribution({
    String? id,
    required this.groupId,
    required this.memberId,
    required this.amount,
    required this.date,
    required this.type,
    this.cycleId,
    this.potId,
    this.mpesaReceiptCode,
    this.reference,
    this.isCash = false,
    this.recordedBy,
    DateTime? createdAt,
    this.isReconciled = false,
    this.reconciliationId,
  }) : id = id ?? _uuid.v4(),
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'groupId': groupId,
        'memberId': memberId,
        'amount': amount,
        'date': date.toIso8601String(),
        'type': type.value,
        'cycleId': cycleId,
        'potId': potId,
        'mpesaReceiptCode': mpesaReceiptCode,
        'reference': reference,
        'isCash': isCash,
        'recordedBy': recordedBy,
        'createdAt': createdAt.toIso8601String(),
        'isReconciled': isReconciled,
        'reconciliationId': reconciliationId,
      };

  factory Contribution.fromJson(Map<String, dynamic> json) => Contribution(
        id: json['id'] as String,
        groupId: json['groupId'] as String,
        memberId: json['memberId'] as String,
        amount: (json['amount'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
        type: _parseType(json['type'] as String),
        cycleId: json['cycleId'] as String?,
        potId: json['potId'] as String?,
        mpesaReceiptCode: json['mpesaReceiptCode'] as String?,
        reference: json['reference'] as String?,
        isCash: json['isCash'] as bool? ?? false,
        recordedBy: json['recordedBy'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        isReconciled: json['isReconciled'] as bool? ?? false,
        reconciliationId: json['reconciliationId'] as String?,
      );

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
}