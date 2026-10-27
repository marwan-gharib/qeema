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

  /// Runs [action] while an OS auth prompt is in flight on behalf of another flow,
  /// so a background/foreground round trip during that prompt neither re-locks the
  /// gate nor lets a resume start a second evaluation.
  Future<T> duringAuthentication<T>(Future<T> Function() action);
}
