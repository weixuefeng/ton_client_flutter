import UIKit
import Flutter
import TonClient
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        dummyMethodToEnforceBundling()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func dummyMethodToEnforceBundling() {
        init_sdk_for_ios()
    }
}
