import '../../../../core/utils/money_format.dart';

/// All Home copy in one place, ready to move to ARB files for Swahili.
abstract final class HomeStrings {
  static const groupBalance = 'GROUP BALANCE';
  static const myBalance = 'MY BALANCE';
  static const collectedThisCycle = 'Collected this cycle';
  static const expectedThisCycle = 'Expected this cycle';
  static const myContributions = 'My contributions';
  static const myArrears = 'My arrears';

  static const quickActions = 'Quick actions';
  static const needsAttention = 'Needs attention';
  static const nextRotationPayout = 'Next rotation payout';
  static const nextPayout = 'Next payout';
  static const recentActivity = 'Recent activity';
  static const seeAll = 'See all';

  static const assign = 'Assign';
  static const view = 'View';
  static const review = 'Review';
  static const viewRotation = 'View rotation';

  static const allCaughtUp = "You're all caught up";
  static const noActiveRotationTitle = 'No active rotation';
  static const noActiveRotationBody =
      'The next payout will show here once a rotation cycle is started.';
  static const noActivityTitle = 'No activity yet';
  static const noActivityBody =
      'Contributions, fines and repayments will appear here.';
  static const yourTurn = 'Your turn';
  static const loadErrorTitle = "Couldn't load your dashboard";
  static const loadErrorBody = 'Check your connection and pull down to try again.';
  static const refreshFailed =
      "Couldn't refresh. Showing the last saved information.";

  static String updated(String when) => 'Updated $when';

  static String unmatchedTitle(int n) =>
      n == 1 ? '1 unmatched M-Pesa payment' : '$n unmatched M-Pesa payments';
  static String unmatchedSubtitle(int minor) =>
      '${MoneyFormat.kes(minor)} awaiting allocation';

  static String arrearsTitle(int n) =>
      n == 1 ? '1 member has arrears' : '$n members have arrears';
  static String arrearsSubtitle(int minor) =>
      '${MoneyFormat.kes(minor)} overdue';

  static String approvalsTitle(int n) =>
      n == 1 ? '1 approval is waiting for you' : '$n approvals are waiting for you';
  static const approvalsSubtitle =
      'Fines, payouts, corrections and loans need a decision';

  static String memberNo(String no) => 'Member #$no';
  static String payoutDate(String date) => 'Payout date: $date';
}