import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ton_client_flutter_platform_interface.dart';

/// An implementation of [TonClientFlutterPlatform] that uses method channels.
class MethodChannelTonClientFlutter extends TonClientFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ton_client_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
