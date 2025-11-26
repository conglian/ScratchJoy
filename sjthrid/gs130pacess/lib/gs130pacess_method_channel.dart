import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'gs130pacess_platform_interface.dart';

/// An implementation of [Gs130pacessPlatform] that uses method channels.
class MethodChannelGs130pacess extends Gs130pacessPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('gs130pacess');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> openBrowser(String url) async {
    try {
      await methodChannel.invokeMethod('openBrowser', {'url': url});
    } catch (e) {
      print('Gs130pacess openBrowser error: $e');
    }
  }
}
