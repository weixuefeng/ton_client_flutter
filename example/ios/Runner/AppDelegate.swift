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
        let starLen = max("{}".utf8.count, 41)
          var starBuf: [CChar] = Array(repeating: 0, count: starLen+1)
          strcpy(&starBuf, "haha")
        dart_create_context(1, &starBuf)
    }
}
