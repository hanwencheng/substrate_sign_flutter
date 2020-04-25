import Flutter
import UIKit

public class SwiftSubstrateSignFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
//     let channel = FlutterMethodChannel(name: "substrate_sign_flutter", binaryMessenger: registrar.messenger())
//     let instance = SwiftSubstrateSignFlutterPlugin()
//     registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS")
  }

    public func dummyMethodToEnforceBundling() {
      // dummy calls to prevent tree shaking
      random_phrase(12);
    }
}
