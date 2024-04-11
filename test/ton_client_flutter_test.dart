import 'package:flutter_test/flutter_test.dart';
import 'package:ton_client_flutter/ton_client_flutter.dart';
import 'package:ton_client_flutter/ton_client_flutter_platform_interface.dart';
import 'package:ton_client_flutter/ton_client_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTonClientFlutterPlatform
    with MockPlatformInterfaceMixin
    implements TonClientFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TonClientFlutterPlatform initialPlatform = TonClientFlutterPlatform.instance;

  test('$MethodChannelTonClientFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTonClientFlutter>());
  });

  test('getPlatformVersion', () async {
    TonClientFlutter tonClientFlutterPlugin = TonClientFlutter();
    MockTonClientFlutterPlatform fakePlatform = MockTonClientFlutterPlatform();
    TonClientFlutterPlatform.instance = fakePlatform;

    expect(await tonClientFlutterPlugin.getPlatformVersion(), '42');
  });
}
