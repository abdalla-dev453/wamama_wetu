import 'package:flutter/foundation.dart';

import 'app_role.dart';

/// The signed-in user in the group they are currently working in.
@immutable
class AppSession {
  const AppSession({
    required this.userId,
    required this.userName,
    required this.role,
    required this.groupId,
    required this.groupName,
    required this.memberId,
    required this.memberNo,
  });

  final String userId;
  final String userName;
  final AppRole role;
  final String groupId;
  final String groupName;
  final String memberId;

  /// Member number as printed on statements and used in M-Pesa references.
  final String memberNo;

  AppSession copyWith({AppRole? role}) => AppSession(
        userId: userId,
        userName: userName,
        role: role ?? this.role,
        groupId: groupId,
        groupName: groupName,
        memberId: memberId,
        memberNo: memberNo,
      );
}