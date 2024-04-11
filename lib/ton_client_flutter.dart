import 'ton_client_flutter_platform_interface.dart';

class TonClientFlutter {
  Future<String?> getPlatformVersion() {
    return TonClientFlutterPlatform.instance.getPlatformVersion();
  }
}
