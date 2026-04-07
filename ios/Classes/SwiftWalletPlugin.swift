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
    switch call.method {
    case "presentAddPassViewController":
      handleAddPassToWallet(call, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func handleAddPassToWallet(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    // Dart sends List<int> which arrives as [Any] (array of NSNumber), not FlutterStandardTypedData.
    // We must cast to [Any] and convert each element to UInt8 to build a Data object.
    guard let args = call.arguments as? [String: Any],
          let rawBytes = args["pkpass"] as? [Any],
          !rawBytes.isEmpty else {
      result(FlutterError(
        code: "INVALID_ARGUMENTS",
        message: "The 'pkpass' parameter is missing or empty",
        details: nil
      ))
      return
    }

    let bytes = rawBytes.compactMap { ($0 as? NSNumber)?.uint8Value }
    guard bytes.count == rawBytes.count else {
      result(FlutterError(
        code: "INVALID_ARGUMENTS",
        message: "The 'pkpass' bytes could not be parsed",
        details: nil
      ))
      return
    }

    let passData = Data(bytes)

    do {
      // Create a PKPass object from the provided data
      let pass = try PKPass(data: passData)

      // Check if the pass is already in the wallet
      let passLibrary = PKPassLibrary()
      if passLibrary.containsPass(pass) {
        result(FlutterError(
          code: "PASS_ALREADY_ADDED",
          message: "The pass is already in the wallet",
          details: nil
        ))
        return
      }

      // Create and present the PKAddPassesViewController
      guard let addPassViewController = PKAddPassesViewController(pass: pass) else {
        result(FlutterError(
          code: "VIEW_CONTROLLER_ERROR",
          message: "Failed to create PKAddPassesViewController",
          details: nil
        ))
        return
      }

      // Present the view controller
      if let rootViewController = SwiftWalletPlugin.topViewController() {
        rootViewController.present(addPassViewController, animated: true) {
          result(true)
        }
      } else {
        result(FlutterError(
          code: "ROOT_VIEW_CONTROLLER_ERROR",
          message: "Failed to access the root view controller",
          details: nil
        ))
      }
    } catch {
      // Handle errors during PKPass creation
      result(FlutterError(
        code: "INVALID_PASS_DATA",
        message: "The provided pass data is invalid",
        details: error.localizedDescription
      ))
    }
  }

  // Helper to find the topmost view controller in a multi-scene safe way
    private static func topViewController(base: UIViewController? = {
      // Try to find the active window scene and its key window without using UIApplication.shared directly for app extensions
      if #available(iOS 13.0, *) {
        // Iterate connected scenes to find the foreground active one
        let scenes = (UIApplication.perform(NSSelectorFromString("sharedApplication"))?.takeUnretainedValue() as? UIApplication)?.connectedScenes ?? []
        let windowScene = scenes
          .compactMap { $0 as? UIWindowScene }
          .first { $0.activationState == .foregroundActive }
        let window = windowScene?.windows.first { $0.isKeyWindow } ?? windowScene?.windows.first
        return window?.rootViewController
      } else {
        // Fallback for iOS 12 and earlier
        let app = UIApplication.perform(NSSelectorFromString("sharedApplication"))?.takeUnretainedValue() as? UIApplication
        return app?.keyWindow?.rootViewController
      }
    }()) -> UIViewController? {
      if let nav = base as? UINavigationController {
        return topViewController(base: nav.visibleViewController)
      }
      if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
        return topViewController(base: selected)
      }
      if let presented = base?.presentedViewController {
        return topViewController(base: presented)
      }
      return base
    }

}