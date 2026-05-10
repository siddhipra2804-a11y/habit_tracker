import 'package:flutter/material.dart';

void main() => runApp(const HabitTrackerApp());

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Mock Data Structure
  final List<Map<String, String>> _todoHabits = [
    {
      "title": "Mindful Breathing",
      "tag": "Calmness",
      "time": "10 minutes",
      "image": "https://picsum.photos/seed/meditation/200"
    },
    {
      "title": "Drink Water",
      "tag": "Health",
      "time": "Every 2 hours",
      "image": "https://picsum.photos/seed/water/200"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do"),
        centerTitle: true,
        leading: const Icon(Icons.menu),
        actions: const [Padding(padding: EdgeInsets.only(right: 16), child: Icon(Icons.settings))],
      ),
      body: CustomScrollView(
        slivers: [
          // WELCOME SECTION
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Hello, Ric!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  Text("Ready for your daily mindfulness?", style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          ),

          // VERTICAL CATEGORY: TO DO
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final habit = _todoHabits[index];
                  return HabitCard(
                    title: habit['title']!,
                    tag: habit['tag']!,
                    time: habit['time']!,
                    imageUrl: habit['image']!,
                    onComplete: () {
                      setState(() => _todoHabits.removeAt(index));
                    },
                  );
                },
                childCount: _todoHabits.length,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

// CUSTOM CARD COMPONENT
class HabitCard extends StatelessWidget {
  final String title;
  final String tag;
  final String time;
  final String imageUrl;
  final VoidCallback onComplete;

  const HabitCard({
    super.key,
    required this.title,
    required this.tag,
    required this.time,
    required this.imageUrl,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // 1. THUMBNAIL IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Container(
                  width: 70,
                  height: 70,
                  color: Colors.teal[100],
                  child: const Icon(Icons.image),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // 2. TEXT CONTENT (Title, Subtitle, Time)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(tag, style: TextStyle(fontSize: 12, color: Colors.teal[700])),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),

            // 3. ACTION ICONS
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                  onPressed: onComplete, // Mark as Done
                  tooltip: 'Mark as Done',
                ),
                IconButton(
                  icon: const Icon(Icons.edit_note_outlined, color: Colors.blueGrey),
                  onPressed: () {}, // Manage Task
                  tooltip: 'Edit Habit',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}