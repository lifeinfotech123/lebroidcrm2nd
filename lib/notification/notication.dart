import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// ✅ BACKGROUND HANDLER
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("===== BACKGROUND MESSAGE RECEIVED =====");
  debugPrint("Title: ${message.notification?.title}");
  debugPrint("Body: ${message.notification?.body}");
  debugPrint("Data: ${message.data}");

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

  await flutterLocalNotificationsPlugin.initialize(
    settings: const InitializationSettings(android: androidInit),
  );

  // Create channel in background handler too
  const channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  const androidDetails = AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    channelDescription: 'This channel is used for important notifications',
    importance: Importance.max,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
  );

  const notificationDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title: message.notification?.title ?? message.data['title'] ?? "No Title",
    body: message.notification?.body ?? message.data['body'] ?? "No Body",
    notificationDetails: notificationDetails,
  );
}

class NotificationServices {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  late AndroidNotificationChannel channel;

  /// ✅ INIT
  Future<void> init(BuildContext context) async {
    await requestNotificationPermission();

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications',
      importance: Importance.max,
    );

    /// ✅ INIT LOCAL NOTIFICATION
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint("Notification clicked: ${response.payload}");
      },
    );

    /// ✅ CREATE CHANNEL
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// ✅ START LISTENING FOR MESSAGES
    firebaseInit();
    setupInteractMessage();

    await getDeviceToken();
    isTokenRefresh();

    debugPrint("===== NOTIFICATION SERVICES INITIALIZED =====");
  }

  /// ✅ PERMISSION
  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint("Permission: ${settings.authorizationStatus}");
  }

  /// ✅ TOKEN
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    debugPrint("FCM TOKEN: $token");
    return token ?? '';
  }

  /// ✅ FOREGROUND
  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("===== FOREGROUND MESSAGE RECEIVED =====");
      debugPrint("Title: ${message.notification?.title}");
      debugPrint("Body: ${message.notification?.body}");
      debugPrint("Data: ${message.data}");

      const androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        playSound: true,
        enableVibration: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        id: Random().nextInt(100000),
        title: message.notification?.title ??
            message.data['title'] ??
            "No Title",
        body:
            message.notification?.body ?? message.data['body'] ?? "No Body",
        notificationDetails: notificationDetails,
      );
    });
  }

  /// ✅ CLICK HANDLING
  void setupInteractMessage() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        debugPrint("Opened from terminated state");
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("Opened from background");
    });
  }

  /// ✅ SHOW (NOTIFICATION PAYLOAD)
  Future<void> showNotification(RemoteMessage message) async {
    final androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id: Random().nextInt(100000),
      title: message.notification?.title ?? "No Title",
      body: message.notification?.body ?? "No Body",
      notificationDetails: notificationDetails,
    );
  }

  /// ✅ SHOW (DATA PAYLOAD)
  Future<void> showNotificationFromData(RemoteMessage message) async {
    final androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id: Random().nextInt(100000),
      title: message.data['title'] ?? "No Title",
      body: message.data['body'] ?? "No Body",
      notificationDetails: notificationDetails,
    );
  }

  /// ✅ TOKEN REFRESH
  void isTokenRefresh() {
    messaging.onTokenRefresh.listen((newToken) {
      debugPrint("FCM Token Refreshed: $newToken");
    });
  }
}