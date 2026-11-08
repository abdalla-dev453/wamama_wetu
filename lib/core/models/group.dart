import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';


final _uuid = Uuid();

@HiveType(typeId: 0)
class Group extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String code; // GROUPCODE for M-PESA reference

  @HiveField(3)
  String? description;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  @HiveField(6)
  bool isActive;

  @HiveField(7)
  String currency; // e.g., "KES"

  @HiveField(8)
  double totalContributions;

  @HiveField(9)
  double totalPayouts;

  @HiveField(10)
  double currentPotBalance;

  @HiveField(11)
  String? paybillNumber; // M-PESA Paybill or Till number

  @HiveField(12)
  int memberCount;

  @HiveField(13)
  String? chairpersonId;

  @HiveField(14)
  String? treasurerId;

  Group({
    String? id,
    required this.name,
    required this.code,
    this.description,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isActive = true,
    this.currency = 'KES',
    this.totalContributions = 0.0,
    this.totalPayouts = 0.0,
    this.currentPotBalance = 0.0,
    this.paybillNumber,
    this.memberCount = 0,
    this.chairpersonId,
    this.treasurerId,
  }) : id = id ?? _uuid.v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'isActive': isActive,
        'currency': currency,
        'totalContributions': totalContributions,
        'totalPayouts': totalPayouts,
        'currentPotBalance': currentPotBalance,
        'paybillNumber': paybillNumber,
        'memberCount': memberCount,
        'chairpersonId': chairpersonId,
        'treasurerId': treasurerId,
      };

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json['id'] as String,
        name: json['name'] as String,
        code: json['code'] as String,
        description: json['description'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        isActive: json['isActive'] as bool? ?? true,
        currency: json['currency'] as String? ?? 'KES',
        totalContributions: (json['totalContributions'] as num?)?.toDouble() ?? 0.0,
        totalPayouts: (json['totalPayouts'] as num?)?.toDouble() ?? 0.0,
        currentPotBalance: (json['currentPotBalance'] as num?)?.toDouble() ?? 0.0,
        paybillNumber: json['paybillNumber'] as String?,
        memberCount: json['memberCount'] as int? ?? 0,
        chairpersonId: json['chairpersonId'] as String?,
        treasurerId: json['treasurerId'] as String?,
      );
}