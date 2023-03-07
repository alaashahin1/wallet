import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class Wallet {
  static const MethodChannel _channel = const MethodChannel('wallet');

  static Future<bool> presentAddPassViewController(
      {required List<int> pkpass}) async {
    if (!Platform.isIOS) return Future.value(false);
    final bool result = await _channel.invokeMethod(
        'presentAddPassViewController', <String, dynamic>{'pkpass': pkpass});
    return result;
  }
}
