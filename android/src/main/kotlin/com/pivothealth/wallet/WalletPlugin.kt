package com.pivothealth.wallet

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** WalletPlugin — Apple Wallet is iOS-only; Android always returns not implemented. */
class WalletPlugin : FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    // Use binaryMessenger (correct API) instead of deprecated getDartExecutor()
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "wallet")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    // Apple Wallet / PKPass is iOS-only; all calls are unsupported on Android.
    result.notImplemented()
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
