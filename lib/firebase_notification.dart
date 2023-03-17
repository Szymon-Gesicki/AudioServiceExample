// ignore_for_file: avoid_print

import 'package:audio_service_example/firebase_options.dart';
import 'package:audio_service_example/local_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// This provided handler must be a top-level function and cannot be
/// anonymous otherwise an [ArgumentError] will be thrown.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  LocalNotification.instance.fire(
    title: message.notification?.title ?? "Title",
    message: message.notification?.body ?? "Body",
  );
}

class FirebaseNotification {
  static FirebaseNotification instance = FirebaseNotification();

  Future<void> init() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotification.instance.fire(
        title: message.notification?.title ?? "title",
        message: message.notification?.body ?? "body",
      );
    });

    try {
      final notificationToken = await FirebaseMessaging.instance.getToken();
      print("TOKEN: $notificationToken");
    } catch (e) {
      print("Error on fetch fcm token $e");
    }
  }
}
