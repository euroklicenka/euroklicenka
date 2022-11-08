import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)


    GMSServices.provideAPIKey("AIzaSyCj76zBj5B7x61hni_9_oRTl3J4zm3PBbk")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}