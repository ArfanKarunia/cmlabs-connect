import 'dart:io';

import 'package:cmlabs_connect/src/controllers/user/user_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotification();
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  UserController userController = Get.put(UserController());

  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationInitialized = false;

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );

    debugPrint("Permission status: ${settings.authorizationStatus}");
  }

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _requestPermission();
    await setupFlutterNotification();
    await _setupMessageHandlers();

    // Handle APNS token for iOS first
    if (Platform.isIOS) {
      await _handleAPNSToken();
    }

    // Get initial FCM token
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        userController.deviceToken.value = token;
        debugPrint("FCM Token: $token");
      } else {
        debugPrint("FCM Token is null");
      }
    } catch (e) {
      if (Platform.isIOS && e.toString().contains('apns-token-not-set')) {
        debugPrint("APNS token not available - this is expected on iOS Simulator");
        debugPrint("FCM token cannot be generated without APNS token on iOS");
        debugPrint("To test push notifications, use a physical iOS device");
      } else {
        debugPrint("Error getting FCM token: $e");
      }
    }

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((fcmToken) {
      debugPrint("FCM Token refreshed: $fcmToken");
      userController.deviceToken.value = fcmToken;
    }).onError((err) {
      debugPrint("Error listening to token refresh: $err");
    });
  }

  Future<void> _handleAPNSToken() async {
    try {
      // Check if running on simulator
      bool isSimulator = await _isRunningOnSimulator();
      
      if (isSimulator) {
        debugPrint("Running on iOS Simulator - APNS tokens are not available");
        debugPrint("Push notifications will not work on simulator. Use a physical device for testing.");
        
        // Set foreground notification options anyway for when it runs on device
        _messaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
        return;
      }

      // Get APNS token with retry mechanism (only on physical device)
      String? apnsToken = await _getAPNSTokenWithRetry();
      if (apnsToken != null) {
        debugPrint("APNS Token: $apnsToken");
        // Set the APNS token to Firebase Messaging
        _messaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      } else {
        debugPrint("APNS token not available after retry attempts");
        debugPrint("Make sure you're running on a physical iOS device and have proper certificates configured");
      }
    } catch (e) {
      debugPrint("Error handling APNS token: $e");
    }
  }

  Future<bool> _isRunningOnSimulator() async {
    try {
      // On iOS simulator, APNS tokens are never available
      // We can check this by trying to get device info or checking model
      return Platform.isIOS && 
             (await _messaging.getAPNSToken() == null) && 
             !await _hasValidAPNSCapability();
    } catch (e) {
      // If we can't determine, assume it's a simulator if APNS fails
      return true;
    }
  }

  Future<bool> _hasValidAPNSCapability() async {
    try {
      // Try to get APNS token once to check if device supports it
      String? token = await _messaging.getAPNSToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<String?> _getAPNSTokenWithRetry({
    int retries = 5,
    Duration delay = const Duration(seconds: 2),
  }) async {
    for (int i = 0; i < retries; i++) {
      try {
        String? apnsToken = await _messaging.getAPNSToken();
        if (apnsToken != null && apnsToken.isNotEmpty) {
          return apnsToken;
        }
        debugPrint("APNS token attempt ${i + 1}/$retries: null or empty");
      } catch (error) {
        debugPrint("Error getting APNS token on attempt ${i + 1}/$retries: $error");
      }
      
      if (i < retries - 1) {
        await Future.delayed(delay);
      }
    }
    return null;
  }

  Future<void> setupFlutterNotification() async {
    if (_isFlutterLocalNotificationInitialized) {
      return;
    }

    // Android-specific setup
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: "This channel is used for important notifications.",
        importance: Importance.high,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );

    _isFlutterLocalNotificationInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@drawable/ic_notification',
          ),
          iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
        ),
        payload: message.data.toString(),
      );
    }
  }

  Future<void> _setupMessageHandlers() async {
    // foreground message
    FirebaseMessaging.onMessage.listen(
      (message) {
        showNotification(message);
      },
    );

    // background message
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    final initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      // open spesific screen
    }
  }
}
