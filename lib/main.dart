import 'package:flutter/material.dart';
import 'navigation.dart'; // Import your navigation file

void main() {
  runApp(const HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Habit Tracker',
      routerConfig: router, // Connect the router here
      debugShowCheckedModeBanner: false,
    );
  }
}