import 'package:flutter/foundation.dart';

/// Router-facing view of the app-lock state, so `core/router` never imports
/// a feature and there is a single state owner for locking.
abstract interface class AppLockGate {
  /// True while protected routes or screens must be shielded behind the lock overlay.
  /// Fail-closed: every state other than unlocked/disabled counts as locked.
  bool get isLocked;

  /// Notified on every lock-state change so listeners re-evaluate.
  Listenable get listenable;

  /// True once the initial cold-start gate decision is completed (unlocked or disabled).
  /// Never resets during the process lifetime so the router subtree stays mounted.
  bool get hasCompletedFirstEntry;
}
