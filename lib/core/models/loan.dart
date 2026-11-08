import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';


final _uuid = Uuid();

enum LoanStatus { active, repaid, defaulted, writtenOff }

@HiveType(typeId: 7)
class Loan extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String groupId;

  @HiveField(2)
  String memberId;

  @HiveField(3)
  double principalAmount;

  @HiveField(4)
  double interestRate; // percentage

  @HiveField(5)
  double totalAmount; // principal + interest

  @HiveField(6)
  double amountRepaid;

  @HiveField(7)
  LoanStatus status;

  @HiveField(8)
  DateTime issuedAt;

  @HiveField(9)
  DateTime? dueDate;

  @HiveField(10)
  DateTime? repaidAt;

  @HiveField(11)
  String? purpose;

  @HiveField(12)
  List<String> guarantorIds;

  Loan({
    String? id,
    required this.groupId,
    required this.memberId,
    required this.principalAmount,
    required this.interestRate,
    required this.totalAmount,
    this.amountRepaid = 0.0,
    this.status = LoanStatus.active,
    DateTime? issuedAt,
    this.dueDate,
    this.repaidAt,
    this.purpose,
    this.guarantorIds = const [],
  }) : id = id ?? _uuid.v4(),
       issuedAt = issuedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'groupId': groupId,
        'memberId': memberId,
        'principalAmount': principalAmount,
        'interestRate': interestRate,
        'totalAmount': totalAmount,
        'amountRepaid': amountRepaid,
        'status': status.toString().split('.').last,
        'issuedAt': issuedAt.toIso8601String(),
        'dueDate': dueDate?.toIso8601String(),
        'repaidAt': repaidAt?.toIso8601String(),
        'purpose': purpose,
        'guarantorIds': guarantorIds,
      };

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
        id: json['id'] as String,
        groupId: json['groupId'] as String,
        memberId: json['memberId'] as String,
        principalAmount: (json['principalAmount'] as num).toDouble(),
        interestRate: (json['interestRate'] as num).toDouble(),
        totalAmount: (json['totalAmount'] as num).toDouble(),
        amountRepaid: (json['amountRepaid'] as num?)?.toDouble() ?? 0.0,
        status: _parseStatus(json['status'] as String),
        issuedAt: DateTime.parse(json['issuedAt'] as String),
        dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
        repaidAt: json['repaidAt'] != null ? DateTime.parse(json['repaidAt']) : null,
        purpose: json['purpose'] as String?,
        guarantorIds: (json['guarantorIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
      );

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

  double get remainingBalance => totalAmount - amountRepaid;
  double get repaymentProgress => totalAmount > 0 ? (amountRepaid / totalAmount * 100) : 0.0;
}