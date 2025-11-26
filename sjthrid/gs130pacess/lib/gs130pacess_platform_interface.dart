import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'gs130pacess_method_channel.dart';

abstract class Gs130pacessPlatform extends PlatformInterface {
  /// Constructs a Gs130pacessPlatform.
  Gs130pacessPlatform() : super(token: _token);

  static final Object _token = Object();

  static Gs130pacessPlatform _instance = MethodChannelGs130pacess();

  /// The default instance of [Gs130pacessPlatform] to use.
  ///
  /// Defaults to [MethodChannelGs130pacess].
  static Gs130pacessPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Gs130pacessPlatform] when
  /// they register themselves.
  static set instance(Gs130pacessPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }


  /// 打开浏览器 / intent:// 链接
  Future<void> openBrowser(String url) {
    throw UnimplementedError('openBrowser() has not been implemented.');
  }
}
