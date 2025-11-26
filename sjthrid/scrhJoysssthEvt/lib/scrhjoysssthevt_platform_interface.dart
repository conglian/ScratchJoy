import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'scrhjoysssthevt_method_channel.dart';

abstract class ScrhjoysssthevtPlatform extends PlatformInterface {
  /// Constructs a ScrhjoysssthevtPlatform.
  ScrhjoysssthevtPlatform() : super(token: _token);

  static final Object _token = Object();

  static ScrhjoysssthevtPlatform _instance = MethodChannelScrhjoysssthevt();

  /// The default instance of [ScrhjoysssthevtPlatform] to use.
  ///
  /// Defaults to [MethodChannelScrhjoysssthevt].
  static ScrhjoysssthevtPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ScrhjoysssthevtPlatform] when
  /// they register themselves.
  static set instance(ScrhjoysssthevtPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
