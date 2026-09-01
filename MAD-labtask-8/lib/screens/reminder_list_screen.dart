import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reminder_model.dart';

class ReminderListScreen extends StatelessWidget {
  const ReminderListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ReminderProvider>(
      builder: (context, reminderProvider, child) {
        if (reminderProvider.reminders.isEmpty) {
          return const Center(
            child: Text('No reminders set. Add one by tapping the + button.'),
          );
        }

        return ListView.builder(
          itemCount: reminderProvider.reminders.length,
          itemBuilder: (context, index) {
            final reminder = reminderProvider.reminders[index];
            return ListTile(
              title: Text(reminder.title),
              subtitle: Text(
                'Lat: ${reminder.latitude.toStringAsFixed(4)}, '
                'Lng: ${reminder.longitude.toStringAsFixed(4)}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  reminderProvider.removeReminder(reminder.id);
                },
              ),
            );
          },
        );
      },
    );
  }
}
