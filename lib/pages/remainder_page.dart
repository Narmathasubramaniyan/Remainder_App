import 'package:flutter/material.dart';
import 'package:remainder/service/notification_helper.dart';
import 'package:remainder/widgets/dropdown_widget.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class RemainderPage extends StatefulWidget {
  const RemainderPage({super.key});

  @override
  State<RemainderPage> createState() => _RemainderPageState();
}

class _RemainderPageState extends State<RemainderPage> {
  String? selectedDay;
  TimeOfDay? selectedTime;
  String? selectedActivity;
  String? selectedPeriod; // AM/PM selection
  List<String> reminders = [];

  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final List<String> activities = [
    'Wake up',
    'Go to gym',
    'Breakfast',
    'Meetings',
    'Lunch',
    'Quick nap',
    'Go to library',
    'Dinner',
    'Go to sleep',
  ];

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones(); // Initialize timezone data
    NotificationHelper.init(); // Initialize the NotificationHelper
  }

  void _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> scheduleNotification(TimeOfDay time) async {
    final now = DateTime.now();
    final hour = time.hour == 12
        ? (selectedPeriod == 'AM' ? 0 : 12)
        : (time.hour % 12 + (selectedPeriod == 'PM' ? 12 : 0));
    final scheduledDate =
        DateTime(now.year, now.month, now.day, hour, time.minute);

    var finalScheduledDate = scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;

    // Create a timezone-aware date
    final tz.TZDateTime tzDateTime =
        tz.TZDateTime.from(finalScheduledDate, tz.local);

    try {
      await NotificationHelper.scheduleNotification(
        tzDateTime,
        'Reminder',
        'Time to $selectedActivity!',
      );

      // Add the reminder to the list
      String reminder =
          '$selectedDay at ${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')} - $selectedActivity';
      setState(() {
        reminders.add(reminder);
      });
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: const Text('R E M A I N D E R A P P'),
        titleTextStyle: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.yellow[400],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dropdown for selecting the day
            DropdownWidget<String>(
              label: 'Select Day',
              value: selectedDay,
              items: daysOfWeek.map((day) {
                return DropdownMenuItem<String>(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDay = value;
                });
              },
            ),
            const SizedBox(height: 20),
            // Gesture Detector for selecting time
            GestureDetector(
              onTap: () => _selectTime(context),
              child: Container(
                height: 60,
                margin: const EdgeInsets.all(16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.yellow[400],
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Center(
                  child: Text(
                    selectedTime == null
                        ? 'Select Time'
                        : 'Selected Time: ${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            // Dropdown for selecting the activity
            DropdownWidget<String>(
              label: 'Select Activity',
              value: selectedActivity,
              items: activities.map((activity) {
                return DropdownMenuItem<String>(
                  value: activity,
                  child: Text(activity),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedActivity = value;
                });
              },
            ),
            const SizedBox(height: 20),
            // Gesture Detector for scheduling the reminder
            GestureDetector(
              onTap: () {
                if (selectedDay != null &&
                    selectedTime != null &&
                    selectedActivity != null) {
                  scheduleNotification(selectedTime!);
                }
              },
              child: Container(
                height: 60,
                margin: const EdgeInsets.all(16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.yellow[400],
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: const Center(
                  child: Text(
                    'Schedule Reminder',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // List of scheduled reminders
            Expanded(
              child: ListView.builder(
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(reminders[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          reminders.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
