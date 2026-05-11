import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const NotificationsScreen(),
    );
  }
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool notificationsEnabled = false;
  List<String> selectedHabits = [];
  List<String> selectedTimes = [];
  Map<String, String> allHabitsMap = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 1. Define the habits you want to see by default
    Map<String, String> defaultHabits = {
      'Drink Water': '#00BFFF',
      'Read a Book': '#8B4513',
    };

    // 2. Load existing habits from storage
    String? storedHabits = prefs.getString('selectedHabitsMap');
    Map<String, String> loadedMap = {};

    if (storedHabits != null && storedHabits.isNotEmpty) {
      try {
        loadedMap = Map<String, String>.from(jsonDecode(storedHabits));
      } catch (e) {
        debugPrint("Error decoding habits: $e");
      }
    }

    // 3. MERGE: Combine defaults with loaded data so they ALWAYS show up
    final finalMap = {...defaultHabits, ...loadedMap};

    setState(() {
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
      allHabitsMap = finalMap;
      selectedHabits = prefs.getStringList('notificationHabits') ?? [];
      selectedTimes = prefs.getStringList('notificationTimes') ?? [];
    });
  }

  Future<void> _saveNotificationSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', notificationsEnabled);
    await prefs.setStringList('notificationHabits', selectedHabits);
    await prefs.setStringList('notificationTimes', selectedTimes);
    // Save the map so new habits added later are also persisted
    await prefs.setString('selectedHabitsMap', jsonEncode(allHabitsMap));
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    try {
      return Color(int.parse('0x$hexColor'));
    } catch (e) {
      return Colors.blue;
    }
  }

  void _sendTestNotification() {
    if (html.Notification.permission != "granted") {
      html.Notification.requestPermission().then((permission) {
        if (permission == 'granted') {
          html.Notification("Habit Reminder",
              body: "It's time to work on your habits!");
        }
      });
    } else {
      html.Notification("Habit Reminder",
          body: "It's time to work on your habits!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        title: const Text('Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Enable Notifications'),
              subtitle: const Text('Get alerts for your daily habits'),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
                _saveNotificationSettings();
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Select Habits for Notification',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            // THE HABIT CHIPS SECTION
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: allHabitsMap.entries.map((entry) {
                final habit = entry.key;
                final color = _getColorFromHex(entry.value);
                final isSelected = selectedHabits.contains(habit);

                return FilterChip(
                  label: Text(habit),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : color,
                    fontWeight: FontWeight.bold,
                  ),
                  selected: isSelected,
                  selectedColor: color,
                  checkmarkColor: Colors.white,
                  backgroundColor: Colors.white,
                  side: BorderSide(color: color, width: 2.0),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedHabits.add(habit);
                      } else {
                        selectedHabits.remove(habit);
                      }
                    });
                    _saveNotificationSettings();
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 25),
            const Text(
              'Select Times for Notification',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: ['Morning', 'Afternoon', 'Evening'].map((time) {
                return ChoiceChip(
                  label: Text(time),
                  selected: selectedTimes.contains(time),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedTimes.add(time);
                      } else {
                        selectedTimes.remove(time);
                      }
                    });
                    _saveNotificationSettings();
                  },
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _sendTestNotification,
                icon: const Icon(Icons.notifications_active),
                label: const Text('Send Test Notification'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}