import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder_model.dart';
import 'notification_service.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  final NotificationService _notificationService = NotificationService();
  Timer? _locationTimer;

  Future<void> initialize() async {
    await _requestPermissions();
    await _initializeBackgroundService();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      status = await Permission.locationAlways.request();
    }

    await Permission.notification.request();
  }

  Future<void> _initializeBackgroundService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        notificationChannelId: 'location_reminder_channel',
        initialNotificationTitle: 'Location Reminder',
        initialNotificationContent: 'Running in background',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );

    service.startService();
  }

  static void onStart(ServiceInstance service) {
    Timer.periodic(const Duration(minutes: 1), (timer) async {
      checkNearbyReminders();
    });
  }

  static Future<bool> onIosBackground(ServiceInstance service) async {
    return true;
  }

  static void checkNearbyReminders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final remindersList = prefs.getStringList('reminders') ?? [];

      if (remindersList.isEmpty) return;

      Position position = await Geolocator.getCurrentPosition();

      for (var reminderJson in remindersList) {
        Map<String, dynamic> reminderMap = jsonDecode(reminderJson);
        Reminder reminder = Reminder.fromJson(reminderMap);

        double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          reminder.latitude,
          reminder.longitude,
        );

        if (distance <= reminder.radius) {
          NotificationService().showNotification(
            reminder.id,
            'Location Reminder',
            'You have reached: ${reminder.title}',
          );
        }
      }
    } catch (e) {
      print('Error checking nearby reminders: $e');
    }
  }
}
