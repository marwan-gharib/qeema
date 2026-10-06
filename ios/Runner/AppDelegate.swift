import Flutter
import UIKit

/// Holds the policy Dart sets for the app-switcher preview and owns the opaque
/// cover iOS captures in that preview.
///
/// iOS takes the recents snapshot as the scene resigns active, which can happen
/// before a `MethodChannel` call made from Dart's `paused` lifecycle event has
/// reached the platform thread. The cover is therefore attached from
/// `sceneWillResignActive` (see `SceneDelegate`) using the last flag Dart
/// delivered, and stays attached for as long as the app is backgrounded so
/// memory-pressure and termination snapshots are covered too.
final class QeemaWindowSecurity {
  static let shared = QeemaWindowSecurity()

  static let channelName = "qeema/window_security"
  static let setRecentsPreviewHiddenMethod = "setRecentsPreviewHidden"

  private var recentsPreviewHidden = true
  private var cover: UIView?

  private init() {}

  func setRecentsPreviewHidden(_ hidden: Bool) {
    recentsPreviewHidden = hidden
    if !hidden {
      removeCover()
    }
  }

  /// Attaches the cover to the scene's key window when Dart asked for the
  /// preview to be hidden. No-op when the gate is open, so an unlocked app
  /// keeps an ordinary snapshot.
  func coverForRecents(in scene: UIScene) {
    guard recentsPreviewHidden,
          let windowScene = scene as? UIWindowScene,
          let window = windowScene.windows.first(where: { $0.isKeyWindow })
              ?? windowScene.windows.first
    else { return }
    if cover?.superview === window { return }
    removeCover()
    let view = UIView(frame: window.bounds)
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.backgroundColor = window.backgroundColor ?? .systemBackground
    view.isUserInteractionEnabled = false
    window.addSubview(view)
    cover = view
  }

  func removeCover() {
    cover?.removeFromSuperview()
    cover = nil
  }
}

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "QeemaWindowSecurity")
    let channel = FlutterMethodChannel(
      name: QeemaWindowSecurity.channelName,
      binaryMessenger: registrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      guard call.method == QeemaWindowSecurity.setRecentsPreviewHiddenMethod else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard let args = call.arguments as? [String: Any],
            let hidden = args["hidden"] as? Bool else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "The 'hidden' argument must be a boolean.", details: nil))
        return
      }
      QeemaWindowSecurity.shared.setRecentsPreviewHidden(hidden)
      result(nil)
    }
  }
}
