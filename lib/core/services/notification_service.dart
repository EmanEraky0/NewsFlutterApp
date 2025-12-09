import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static String? deviceToken;

  static Future<void> initialize() async {
    await _initLocalNotifications();
    await setupFCM();
  }


  static Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        print("User tapped on a notification: ${response.payload}");
      },
    );

    // Android channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'news_channel_id',
      'News Notifications',
      description: 'This channel is used for critical notifications.',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }


  static Future<void> setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permissions (iOS)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("iOS Permission: ${settings.authorizationStatus}");

    deviceToken = await messaging.getToken();
    print("FCM Token: $deviceToken");


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final android = message.notification?.android;

      if (notification != null) {
        _showLocalNotification(notification);
        _showDialog(notification.title!, notification.body!);
      }

      print("Foreground message: ${notification?.title}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Notification opened app: ${message.data}");
    });

    RemoteMessage? initialMsg = await messaging.getInitialMessage();
    if (initialMsg != null) {
      print("Opened from terminated state: ${initialMsg.data}");
    }
  }

  static void _showLocalNotification(RemoteNotification notification) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'news_channel_id',
          'News Notifications',
          channelDescription: 'Used for important notifications.',
          priority: Priority.high,
          importance: Importance.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }





  static void _showDialog(String title, String body) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
