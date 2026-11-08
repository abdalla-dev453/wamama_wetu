import '../domain/app_role.dart';
import '../domain/app_session.dart';

/// MOCK: fixed sessions for development. Replaced by phone + OTP login.
abstract final class MockSessions {
  static const AppSession treasurer = AppSession(
    userId: 'u-001',
    userName: 'Wanjiku Mwangi',
    role: AppRole.treasurer,
    groupId: 'g-umoja',
    groupName: 'Umoja Savings Group',
    memberId: 'm-001',
    memberNo: '001',
  );

  static AppSession forRole(AppRole role) => treasurer.copyWith(role: role);
}
