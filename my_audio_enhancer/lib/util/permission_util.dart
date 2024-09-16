import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  const PermissionUtil._();

  static Future<void> requestVideoPermission() async {
    var status = await Permission.videos.status;
    if (!status.isGranted) {
      await Permission.videos.request();
    }
  }

  static Future<bool> get checkVideoPermissionIsGranted => Permission.videos.status.isGranted;
}
