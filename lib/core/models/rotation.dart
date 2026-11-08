import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';


final _uuid = Uuid();

enum RotationOrderType { ballot, manual, swap, postponement }

@HiveType(typeId: 4)
class RotationEntry extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String groupId;

  @HiveField(2)
  String memberId;

  @HiveField(3)
  int position; // Position in rotation (1 = first to receive)

  @HiveField(4)
  DateTime payoutDate;

  @HiveField(5)
  double potAmount;

  @HiveField(6)
  bool isPaidOut;

  @HiveField(7)
  DateTime? paidOutAt;

  @HiveField(8)
  RotationOrderType orderType;

  @HiveField(9)
  String? swappedFromMemberId;

  @HiveField(10)
  String? swappedToMemberId;

  @HiveField(11)
  String? postponementReason;

  @HiveField(12)
  String? approvedBy;

  @HiveField(13)
  DateTime createdAt;

  RotationEntry({
    String? id,
    required this.groupId,
    required this.memberId,
    required this.position,
    required this.payoutDate,
    required this.potAmount,
    this.isPaidOut = false,
    this.paidOutAt,
    this.orderType = RotationOrderType.manual,
    this.swappedFromMemberId,
    this.swappedToMemberId,
    this.postponementReason,
    this.approvedBy,
    DateTime? createdAt,
  }) : id = id ?? _uuid.v4(),
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'groupId': groupId,
        'memberId': memberId,
        'position': position,
        'payoutDate': payoutDate.toIso8601String(),
        'potAmount': potAmount,
        'isPaidOut': isPaidOut,
        'paidOutAt': paidOutAt?.toIso8601String(),
        'orderType': orderType.toString().split('.').last,
        'swappedFromMemberId': swappedFromMemberId,
        'swappedToMemberId': swappedToMemberId,
        'postponementReason': postponementReason,
        'approvedBy': approvedBy,
        'createdAt': createdAt.toIso8601String(),
      };

  factory RotationEntry.fromJson(Map<String, dynamic> json) => RotationEntry(
        id: json['id'] as String,
        groupId: json['groupId'] as String,
        memberId: json['memberId'] as String,
        position: json['position'] as int,
        payoutDate: DateTime.parse(json['payoutDate'] as String),
        potAmount: (json['potAmount'] as num).toDouble(),
        isPaidOut: json['isPaidOut'] as bool? ?? false,
        paidOutAt: json['paidOutAt'] != null ? DateTime.parse(json['paidOutAt']) : null,
        orderType: _parseOrderType(json['orderType'] as String),
        swappedFromMemberId: json['swappedFromMemberId'] as String?,
        swappedToMemberId: json['swappedToMemberId'] as String?,
        postponementReason: json['postponementReason'] as String?,
        approvedBy: json['approvedBy'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

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
}