import 'package:flutter/foundation.dart';

class Reminder {
  final String id;
  final String title;
  final double latitude;
  final double longitude;
  final double radius; // meters

  Reminder({
    required this.id,
    required this.title,
    required this.latitude,
    required this.longitude,
    this.radius = 100, // Default radius of 100 meters
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      title: json['title'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      radius: json['radius'],
    );
  }
}

class ReminderProvider with ChangeNotifier {
  List<Reminder> _reminders = [];

  List<Reminder> get reminders => _reminders;

  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
    notifyListeners();
  }

  void removeReminder(String id) {
    _reminders.removeWhere((reminder) => reminder.id == id);
    notifyListeners();
  }
}
