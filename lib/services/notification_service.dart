import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../utils/app_constants.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Initialize timezone
    tz.initializeTimeZones();

    // Request notification permission
    await _requestPermissions();

    // // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/launcher_icon');    // iOS initialization
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    await _createNotificationChannel();
  }

  Future<void> _requestPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      AppConstants.NOTIFICATION_CHANNEL_ID,
      AppConstants.NOTIFICATION_CHANNEL_NAME,
      description: 'Blood donation eligibility reminders',
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _onNotificationTapped(NotificationResponse notificationResponse) {
    // Handle notification tap if needed
    print('Notification tapped: ${notificationResponse.payload}');
  }

  Future<void> scheduleDonationReminder(DateTime lastDonationDate) async {
    // Calculate 6 months from last donation date
    final reminderDate = DateTime(
      lastDonationDate.year,
      lastDonationDate.month + 6,
      lastDonationDate.day,
    );

    // Only schedule if the reminder date is in the future
    if (reminderDate.isAfter(DateTime.now())) {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        AppConstants.DONATION_REMINDER_ID,
        'Ready to Donate Again! 🩸',
        'It\'s been 6 months since your last donation. You\'re now eligible to donate blood again and help save lives!',
        tz.TZDateTime.from(reminderDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            AppConstants.NOTIFICATION_CHANNEL_ID,
            AppConstants.NOTIFICATION_CHANNEL_NAME,
            channelDescription: 'Blood donation eligibility reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'donation_reminder',
      );
    }
  }

  Future<void> cancelDonationReminder() async {
    await _flutterLocalNotificationsPlugin.cancel(AppConstants.DONATION_REMINDER_ID);
  }

  // Method to reschedule notification when user makes a new donation
  Future<void> updateDonationReminder(DateTime newDonationDate) async {
    // Cancel existing reminder
    await cancelDonationReminder();

    // Schedule new reminder
    await scheduleDonationReminder(newDonationDate);
  }

  // Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final permission = await Permission.notification.status;
    return permission.isGranted;
  }

  // Method to request permission if denied
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }
}