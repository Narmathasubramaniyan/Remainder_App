import 'package:flutter/material.dart';
import 'package:remainder/pages/remainder_page.dart';
import 'package:remainder/service/notification_helper.dart';
import 'package:timezone/data/latest_all.dart' as tz; // Corrected import

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); // Initialize timezone data correctly
  NotificationHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RemainderPage(),
    );
  }
}
