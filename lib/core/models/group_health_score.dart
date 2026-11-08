import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';


final _uuid = Uuid();

@HiveType(typeId: 6)
class GroupHealthScore extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String groupId;

  @HiveField(2)
  int score; // 0-100

  @HiveField(3)
  double collectionRate; // 0-100

  @HiveField(4)
  double arrearsRate; // 0-100

  @HiveField(5)
  double loanRepaymentRate; // 0-100

  @HiveField(6)
  double meetingAttendanceRate; // 0-100

  @HiveField(7)
  int unmatchedPaymentsCount;

  @HiveField(8)
  List<String> recommendedActions;

  @HiveField(9)
  DateTime calculatedAt;

  GroupHealthScore({
    String? id,
    required this.groupId,
    this.score = 0,
    this.collectionRate = 0.0,
    this.arrearsRate = 0.0,
    this.loanRepaymentRate = 0.0,
    this.meetingAttendanceRate = 0.0,
    this.unmatchedPaymentsCount = 0,
    this.recommendedActions = const [],
    DateTime? calculatedAt,
  }) : id = id ?? _uuid.v4(),
       calculatedAt = calculatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'groupId': groupId,
        'score': score,
        'collectionRate': collectionRate,
        'arrearsRate': arrearsRate,
        'loanRepaymentRate': loanRepaymentRate,
        'meetingAttendanceRate': meetingAttendanceRate,
        'unmatchedPaymentsCount': unmatchedPaymentsCount,
        'recommendedActions': recommendedActions,
        'calculatedAt': calculatedAt.toIso8601String(),
      };

  factory GroupHealthScore.fromJson(Map<String, dynamic> json) => GroupHealthScore(
        id: json['id'] as String,
        groupId: json['groupId'] as String,
        score: json['score'] as int? ?? 0,
        collectionRate: (json['collectionRate'] as num?)?.toDouble() ?? 0.0,
        arrearsRate: (json['arrearsRate'] as num?)?.toDouble() ?? 0.0,
        loanRepaymentRate: (json['loanRepaymentRate'] as num?)?.toDouble() ?? 0.0,
        meetingAttendanceRate: (json['meetingAttendanceRate'] as num?)?.toDouble() ?? 0.0,
        unmatchedPaymentsCount: json['unmatchedPaymentsCount'] as int? ?? 0,
        recommendedActions: (json['recommendedActions'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        calculatedAt: DateTime.parse(json['calculatedAt'] as String),
      );

  String get scoreLabel {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    if (score >= 20) return 'Poor';
    return 'Critical';
  }

  Color get scoreColor {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.lightGreen;
    if (score >= 40) return Colors.orange;
    if (score >= 20) return Colors.deepOrange;
    return Colors.red;
  }
}