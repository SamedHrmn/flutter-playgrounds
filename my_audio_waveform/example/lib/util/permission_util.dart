import 'package:permission_handler/permission_handler.dart';

final class PermissionUtil {
  static Future<bool> hasMicrophonePermission() async {
    return Permission.microphone.isGranted;
  }

  static Future<void> askMicrophonePermission() async {
    await Permission.microphone.request();
  }
}
