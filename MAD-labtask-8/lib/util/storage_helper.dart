import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder_model.dart';

class StorageHelper {
  static Future<void> saveReminders(List<Reminder> reminders) async {
    final prefs = await SharedPreferences.getInstance();
    final reminderJsonList =
        reminders.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList('reminders', reminderJsonList);
  }

  static Future<List<Reminder>> loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final reminderJsonList = prefs.getStringList('reminders') ?? [];

    return reminderJsonList
        .map((jsonStr) => Reminder.fromJson(jsonDecode(jsonStr)))
        .toList();
  }
}
