import 'dart:io';

import 'package:cmlabs_connect/src/controllers/user/user_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

/// Background entry point invoked by Firebase Messaging when a push
/// notification is received and the app is in the background/terminated.
///
/// This ensures the local notifications plugin is initialized and then
/// displays the incoming notification.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotification();
  await NotificationService.instance.showNotification(message);
}

/// Service responsible for configuring push notifications (FCM),
/// handling iOS APNS specifics, and showing local notifications
/// while the app is in the foreground/background.
class NotificationService {
  UserController userController = Get.put(UserController());

  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationInitialized = false;

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
  }

  /// Initializes Firebase Messaging and the local notifications plugin.
  ///
  /// Steps:
  /// - Registers the background handler
  /// - Requests notification permissions
  /// - Initializes local notification channels/settings
  /// - Sets up foreground/background message listeners
  /// - On iOS, handles APNS token availability and presentation options
  /// - Retrieves and stores the FCM token, and listens for token refreshes
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
      }
    } catch (_) {
      // Intentionally ignore token retrieval errors. On iOS Simulator, APNS
      // is unavailable, and therefore FCM token generation will fail.
    }

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((fcmToken) {
      userController.deviceToken.value = fcmToken;
    }).onError((_) {});
  }

  /// Ensures APNS token and iOS foreground presentation behavior are handled.
  ///
  /// On Simulator, APNS is not available; presentation options are still set
  /// so that running on device later will behave correctly. On a physical
  /// device, attempts to acquire the APNS token with a simple retry strategy
  /// before setting foreground presentation options.
  Future<void> _handleAPNSToken() async {
    try {
      // Check if running on simulator
      bool isSimulator = await _isRunningOnSimulator();
      
      if (isSimulator) {
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
        // Set the APNS token to Firebase Messaging
        _messaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    } catch (_) {}
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

  /// Attempts to retrieve an APNS token several times with delay between tries.
  ///
  /// Returns the token if available, otherwise `null` after all attempts.
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
      } catch (_) {
        return null;
      }
      
      if (i < retries - 1) {
        await Future.delayed(delay);
      }
    }
    return null;
  }

  /// Initializes local notifications on both Android and iOS.
  ///
  /// On Android, creates a high-importance notification channel used to
  /// display heads-up notifications. On iOS, requests the relevant
  /// presentation permissions.
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

  /// Displays a local notification for an incoming [RemoteMessage].
  ///
  /// Only shows the notification if it contains an Android notification
  /// payload. On iOS, display behavior is governed by foreground
  /// presentation options set earlier.
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

  /// Wires up listeners for foreground and background notification events.
  ///
  /// - Foreground: shows a local notification
  /// - Background/opened: delegates to background message handler
  /// - App launch via notification: handles the initial notification
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

  /// Handles navigation or side-effects when a notification is tapped
  /// and the app is brought to the foreground from background/terminated.
  void _handleBackgroundMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      // open spesific screen
    }
  }
}
