enum AppLockStatus {
  /// The OS confirmed there is no lock to prompt for — the app may open.
  notRequired,

  /// The OS reported a successful authentication.
  authenticated,

  /// The user cancelled or failed the OS prompt.
  failed,

  /// Too many failed attempts; the OS owns the cooldown.
  lockedOut,
}
