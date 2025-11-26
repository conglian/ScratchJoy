import 'package:flutter_test/flutter_test.dart';
import 'package:scrhjoysssthevt/scrhjoysssthevt.dart';
import 'package:scrhjoysssthevt/scrhjoysssthevt_platform_interface.dart';
import 'package:scrhjoysssthevt/scrhjoysssthevt_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockScrhjoysssthevtPlatform
    with MockPlatformInterfaceMixin
    implements ScrhjoysssthevtPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ScrhjoysssthevtPlatform initialPlatform = ScrhjoysssthevtPlatform.instance;

  test('$MethodChannelScrhjoysssthevt is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelScrhjoysssthevt>());
  });

  test('getPlatformVersion', () async {
    Scrhjoysssthevt scrhjoysssthevtPlugin = Scrhjoysssthevt();
    MockScrhjoysssthevtPlatform fakePlatform = MockScrhjoysssthevtPlatform();
    ScrhjoysssthevtPlatform.instance = fakePlatform;

    expect(await scrhjoysssthevtPlugin.getPlatformVersion(), '42');
  });
}
