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
    // Ensure the arguments contain the required 'pkpass' data
    guard let args = call.arguments as? [String: Any],
          let data = args["pkpass"] as? FlutterStandardTypedData,
          !data.data.isEmpty else {
      result(FlutterError(
        code: "INVALID_ARGUMENTS",
        message: "The 'pkpass' parameter is missing or empty",
        details: nil
      ))
      return
    }

    do {
      // Create a PKPass object from the provided data
      let pass = try PKPass(data: data.data)

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
      if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
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
}