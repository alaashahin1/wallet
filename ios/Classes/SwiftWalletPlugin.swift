import Flutter
import PassKit
import UIKit

public class SwiftWalletPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "wallet", binaryMessenger: registrar.messenger())
    let instance = SwiftWalletPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method.compare("presentAddPassViewController") == .orderedSame else {
        return result(FlutterMethodNotImplemented);
    }
    
    guard let args = call.arguments as? [String: Any],
        let data = args["pkpass"] as? FlutterStandardTypedData,
        data.elementCount > 0 else {
        return result(FlutterError(code: "WITHOUT_PARAMETERS",
                                   message: "Don't have 'pkpass' parameter",
                                   details: "You need add 'pkpass' parameter"));
    }
    
    do {
        let newPass = try PKPass(data: data.data)
        guard let addPassViewController = PKAddPassesViewController(pass: newPass) else {
            return result(false);
        }
        
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
            return result(false);
        }
        rootVC.present(addPassViewController, animated: true) {
            return result(true);
        }
    } catch {
         return result(FlutterError(code: "WRONG_PARAMETER",
                                    message: "Your 'pkpass' has wrong information",
                                    details: "make sure pass your 'pkpass' in List<int> from Dart"));
    }
  }
}
