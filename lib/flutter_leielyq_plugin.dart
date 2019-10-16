import 'dart:async';

import 'package:flutter/services.dart';

class FlutterLeielyqPlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_leielyq_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
