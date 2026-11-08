/// Route paths. Tab roots live inside the bottom-navigation shell; everything
/// else is pushed full-screen on top of it.
abstract final class AppRoutes {
  // Tab roots
  static const home = '/home';
  static const members = '/members';
  static const money = '/money';
  static const loans = '/loans';
  static const more = '/more';

  // Pushed screens (placeholders until their features are built)
  static const notifications = '/notifications';
  static const profile = '/profile';
  static const syncQueue = '/sync';
  static const recordContribution = '/money/record-contribution';
  static const reconcile = '/money/reconcile';
  static const unmatchedPayments = '/money/unmatched';
  static const ledger = '/money/ledger';
  static const ledgerEntryPattern = '/ledger/:id';
  static String ledgerEntry(String id) => '/ledger/$id';
  static const addMember = '/members/add';
  static const arrears = '/members/arrears';
  static const myStatement = '/members/me/statement';
  static const rotation = '/rotation';
  static const reports = '/more/reports';
  static const approvals = '/more/approvals';
  static const meetings = '/more/meetings';
  static const settings = '/more/settings';
  static const roles = '/more/roles';
  static const auditTrail = '/more/audit';

  // Debug only
  static const designGallery = '/dev/gallery';
}
