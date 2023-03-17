// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static LocalNotification instance = LocalNotification();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  LocalNotification() {
    _setupNotificationManager();
  }

  Future<void> _setupNotificationManager() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');
    var initializationSettings = const InitializationSettings(
      android: initializationSettingsAndroid,
    );
    try {
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    } catch (e) {
      print("Error on init notification manager $e");
    }
  }

  Future<void> fire(
      {required String title, required String message, String? payload}) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "default_notification_channel",
        "All notifications",
        "All notifications");

    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        UniqueKey().hashCode, title, message, platformChannelSpecifics,
        payload: payload);
  }
}
