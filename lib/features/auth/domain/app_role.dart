/// Roles from the product brief. Drives what each screen shows and which
/// actions are offered. (The backend remains the source of truth for what a
/// role may actually do; the app only hides what it can't use.)
enum AppRole {
  treasurer,
  chairperson,
  secretary,
  member,
  auditor;

  String get label => switch (this) {
        AppRole.treasurer => 'Treasurer',
        AppRole.chairperson => 'Chairperson',
        AppRole.secretary => 'Secretary',
        AppRole.member => 'Member',
        AppRole.auditor => 'Auditor',
      };

  /// Auditors can look at everything but change nothing.
  bool get isReadOnly => this == AppRole.auditor;
}