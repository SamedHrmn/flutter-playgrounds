import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

final class PermissionUtil {
  const PermissionUtil._();

  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  static Future<bool> checkGalleryPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    }

    final status = await Permission.photos.request();
    return status.isGranted;
  }
}
