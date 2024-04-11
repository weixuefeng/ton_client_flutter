import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ton_client_flutter_method_channel.dart';

abstract class TonClientFlutterPlatform extends PlatformInterface {
  /// Constructs a TonClientFlutterPlatform.
  TonClientFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static TonClientFlutterPlatform _instance = MethodChannelTonClientFlutter();

  /// The default instance of [TonClientFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelTonClientFlutter].
  static TonClientFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TonClientFlutterPlatform] when
  /// they register themselves.
  static set instance(TonClientFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
