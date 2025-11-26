
import 'gs130pacess_platform_interface.dart';

class Gs130pacess {
  Future<String?> getPlatformVersion() {
    return Gs130pacessPlatform.instance.getPlatformVersion();
  }

  /// 打开浏览器 / intent:// 链接
  Future<void> openBrowser(String url) {
    return Gs130pacessPlatform.instance.openBrowser(url);
  }
}
