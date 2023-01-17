import 'dart:ui';

import 'package:background_process_sample/util/notification_helper.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'shared_prefs_util.dart';

class BackgroundServiceHelper {
  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await NotificationHelper.instance.initNotification();

    await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: false,
        autoStart: false,
        autoStartOnBoot: false,
        notificationChannelId: NotificationHelper.channelId1,
      ),
    );
  }

  static Future<void> startService(int currentValue) async {
    final service = FlutterBackgroundService();

    await service.startService();

    await SharedPrefsUtil().init();

    await NotificationHelper.showNotification(
      notificationDetails: NotificationHelper.createNotificationDetail(actions: [
        NotificationActions.increase.notificationAction(),
        NotificationActions.decrease.notificationAction(),
      ]),
      id: 1,
      value: (await SharedPrefsUtil().getCounter()).toString(),
    );
  }

  @pragma('vm:entry-point')
  static Future<void> onStart(ServiceInstance serviceInstance) async {
    DartPluginRegistrant.ensureInitialized();

    await SharedPrefsUtil().init();

    await NotificationHelper.showNotification(
      notificationDetails: NotificationHelper.createNotificationDetail(actions: [
        NotificationActions.increase.notificationAction(),
        NotificationActions.decrease.notificationAction(),
      ]),
      id: 1,
      value: (await SharedPrefsUtil().getCounter()).toString(),
    );
  }
}
