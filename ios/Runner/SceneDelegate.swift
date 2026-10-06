import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  override func sceneWillResignActive(_ scene: UIScene) {
    // iOS snapshots the app switcher as the scene resigns active, so the cover
    // has to go up here — a Dart-driven call on the lifecycle `paused` event can
    // arrive after that snapshot was taken.
    QeemaWindowSecurity.shared.coverForRecents(in: scene)
    super.sceneWillResignActive(scene)
  }

  override func sceneDidBecomeActive(_ scene: UIScene) {
    super.sceneDidBecomeActive(scene)
    QeemaWindowSecurity.shared.removeCover()
  }
}
