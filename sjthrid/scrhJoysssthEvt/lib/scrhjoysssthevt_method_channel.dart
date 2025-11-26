import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'scrhjoysssthevt_platform_interface.dart';

/// An implementation of [ScrhjoysssthevtPlatform] that uses method channels.
class MethodChannelScrhjoysssthevt extends ScrhjoysssthevtPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('scrhjoysssthevt');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
