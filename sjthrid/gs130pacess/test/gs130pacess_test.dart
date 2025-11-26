import 'package:flutter_test/flutter_test.dart';
import 'package:gs130pacess/gs130pacess.dart';
import 'package:gs130pacess/gs130pacess_platform_interface.dart';
import 'package:gs130pacess/gs130pacess_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGs130pacessPlatform
    with MockPlatformInterfaceMixin
    implements Gs130pacessPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final Gs130pacessPlatform initialPlatform = Gs130pacessPlatform.instance;

  test('$MethodChannelGs130pacess is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGs130pacess>());
  });

  test('getPlatformVersion', () async {
    Gs130pacess gs130pacessPlugin = Gs130pacess();
    MockGs130pacessPlatform fakePlatform = MockGs130pacessPlatform();
    Gs130pacessPlatform.instance = fakePlatform;

    expect(await gs130pacessPlugin.getPlatformVersion(), '42');
  });
}
