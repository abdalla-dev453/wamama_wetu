import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';


final _uuid = Uuid();

@HiveType(typeId: 1)
class Member extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String groupId;

  @HiveField(2)
  String memberNumber; // MEMBERNO for M-PESA reference

  @HiveField(3)
  String fullName;

  @HiveField(4)
  String phoneNumber;

  @HiveField(5)
  String? idNumber;

  @HiveField(6)
  DateTime joinedAt;

  @HiveField(7)
  bool isActive;

  @HiveField(8)
  double totalContributed;

  @HiveField(9)
  double totalReceived;

  @HiveField(10)
  double outstandingBalance;

  @HiveField(11)
  bool isChairperson;

  @HiveField(12)
  bool isTreasurer;

  @HiveField(13)
  String? email;

  @HiveField(14)
  String? nextOfKin;

  @HiveField(15)
  String? nextOfKinPhone;

  Member({
    String? id,
    required this.groupId,
    required this.memberNumber,
    required this.fullName,
    required this.phoneNumber,
    this.idNumber,
    DateTime? joinedAt,
    this.isActive = true,
    this.totalContributed = 0.0,
    this.totalReceived = 0.0,
    this.outstandingBalance = 0.0,
    this.isChairperson = false,
    this.isTreasurer = false,
    this.email,
    this.nextOfKin,
    this.nextOfKinPhone,
  }) : id = id ?? _uuid.v4(),
       joinedAt = joinedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'groupId': groupId,
        'memberNumber': memberNumber,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'idNumber': idNumber,
        'joinedAt': joinedAt.toIso8601String(),
        'isActive': isActive,
        'totalContributed': totalContributed,
        'totalReceived': totalReceived,
        'outstandingBalance': outstandingBalance,
        'isChairperson': isChairperson,
        'isTreasurer': isTreasurer,
        'email': email,
        'nextOfKin': nextOfKin,
        'nextOfKinPhone': nextOfKinPhone,
      };

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json['id'] as String,
        groupId: json['groupId'] as String,
        memberNumber: json['memberNumber'] as String,
        fullName: json['fullName'] as String,
        phoneNumber: json['phoneNumber'] as String,
        idNumber: json['idNumber'] as String?,
        joinedAt: DateTime.parse(json['joinedAt'] as String),
        isActive: json['isActive'] as bool? ?? true,
        totalContributed: (json['totalContributed'] as num?)?.toDouble() ?? 0.0,
        totalReceived: (json['totalReceived'] as num?)?.toDouble() ?? 0.0,
        outstandingBalance: (json['outstandingBalance'] as num?)?.toDouble() ?? 0.0,
        isChairperson: json['isChairperson'] as bool? ?? false,
        isTreasurer: json['isTreasurer'] as bool? ?? false,
        email: json['email'] as String?,
        nextOfKin: json['nextOfKin'] as String?,
        nextOfKinPhone: json['nextOfKinPhone'] as String?,
      );
}