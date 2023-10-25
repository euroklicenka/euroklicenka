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


    GMSServices.provideAPIKey("AIzaSyCLHWXTFP6a6RRboMPWU_-T1P9l4PVolPg")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}