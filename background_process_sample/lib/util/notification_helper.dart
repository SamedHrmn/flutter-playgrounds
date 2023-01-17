import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'shared_prefs_util.dart';

enum NotificationActions {
  increase('id_1', Colors.blue),
  decrease('id_2', Colors.red);

  final String id;
  final Color color;
  const NotificationActions(this.id, this.color);
}

extension NotificationActionExtension on NotificationActions {
  AndroidNotificationAction notificationAction() {
    const increaseText = "Increase";
    const decreaseText = "Decrease";
    const errorText = "Error";

    switch (this) {
      case NotificationActions.increase:
        return AndroidNotificationAction(NotificationActions.increase.id, increaseText, cancelNotification: false, titleColor: NotificationActions.increase.color);
      case NotificationActions.decrease:
        return AndroidNotificationAction(NotificationActions.decrease.id, decreaseText, titleColor: NotificationActions.decrease.color);
      default:
        return const AndroidNotificationAction('_', errorText);
    }
  }
}

class NotificationHelper {
  static final NotificationHelper instance = NotificationHelper._();
  static const channelId1 = "my_notification1";
  static const channelId2 = "my_notification2";

  static const channelName = "Counter";

  NotificationHelper._();

  Future<void> initNotification() async {
    const channel = AndroidNotificationChannel(
      channelId1,
      channelName,
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.initialize(const InitializationSettings(android: AndroidInitializationSettings('ic_launcher')),
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground);
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse notificationResponse) async {
    await SharedPrefsUtil().init();

    if (notificationResponse.actionId == NotificationActions.increase.id) {
      await SharedPrefsUtil().setCounter((await SharedPrefsUtil().getCounter() ?? 0) + 1);

      await showNotification(
        notificationDetails: createNotificationDetail(actions: [
          NotificationActions.increase.notificationAction(),
          NotificationActions.decrease.notificationAction(),
        ]),
        id: 1,
        value: (await SharedPrefsUtil().getCounter()).toString(),
      );
    }
  }

  static NotificationDetails createNotificationDetail({List<AndroidNotificationAction>? actions}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId2,
        channelName,
        playSound: false,
        enableVibration: false,
        actions: actions,
      ),
    );
  }

  static Future<void> showNotification({
    required NotificationDetails notificationDetails,
    required int id,
    String? title,
    required String value,
  }) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      value,
      notificationDetails,
    );
  }

  Future<void> cancelAllNotification() async {
    await FlutterLocalNotificationsPlugin().cancelAll();
  }
}
