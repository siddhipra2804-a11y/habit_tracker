import 'package:flutter/material.dart';

void main() => runApp(const HabitTrackerApp());

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- 1. TOP NAVIGATION BAR ---
      appBar: AppBar(
        title: const Text("To Do"),
        centerTitle: true,
        // REMOVED: "leading: Icon(Icons.menu)" 
        // WHY: Adding a 'drawer' below tells Flutter to add the icon AND the logic for you.
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),

      // --- 2. THE DRAWER (This makes the hamburger work) ---
   // --- 2. THE DRAWER ---
      drawer: Drawer(
        child: Column( // Using Column allows us to use Spacer()
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Center(
                child: Text(
                  "Menu", 
                  style: TextStyle(color: Colors.white, fontSize: 24)
                ),
              ),
            ),
            
            // Item 1: Home
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => Navigator.pop(context),
            ),

            // Item 2: Configure Habits (Added this)
            ListTile(
              leading: const Icon(Icons.settings_suggest),
              title: const Text("Configure Habits"),
              onTap: () {
                Navigator.pop(context); // Closes the drawer
                // Logic to open configuration screen goes here
              },
            ),

            const Spacer(), // Pushes the next items to the bottom

            const Divider(), // A subtle line above Sign Out

            // Item 3: Sign Out (Added this)
           ListTile(
  leading: const Icon(Icons.settings_suggest),
  title: const Text("Configure Habits"),
  onTap: () {
    Navigator.pop(context); // Close the drawer first
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ConfigureHabitsScreen()),
    );
  },
),
            const SizedBox(height: 20),
          ],
        ),
      ),

      body: const Center(child: Text("Hello, Ric! Content goes here.")),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ConfigureHabitsScreen extends StatefulWidget {
  const ConfigureHabitsScreen({super.key});

  @override
  State<ConfigureHabitsScreen> createState() => _ConfigureHabitsScreenState();
}

class _ConfigureHabitsScreenState extends State<ConfigureHabitsScreen> {
  // Initial list with your specific requirements
  final List<Map<String, dynamic>> _habits = [
    {'name': 'Workout', 'color': Colors.red},
    {'name': 'Meditate', 'color': Colors.pink},
    {'name': 'Read a book', 'color': Colors.green},
    {'name': 'Drink water', 'color': Colors.blue},
    {'name': 'Practice gratitude', 'color': Colors.yellow},
    {'name': 'Wake up early', 'color': Colors.purple},
  ];

  final TextEditingController _nameController = TextEditingController();
  
  // Available colors for the dropdown
  final Map<String, Color> _colorOptions = {
    'Red': Colors.red,
    'Pink': Colors.pink,
    'Green': Colors.green,
    'Blue': Colors.blue,
    'Yellow': Colors.yellow,
    'Purple': Colors.purple,
    'Teal': Colors.teal,
    'Orange': Colors.orange,
  };

  String _selectedColorName = 'Teal';

  void _addHabit() {
    if (_nameController.text.isNotEmpty) {
      setState(() {
        _habits.add({
          'name': _nameController.text,
          'color': _colorOptions[_selectedColorName],
        });
        _nameController.clear();
      });
    }
  }

  void _deleteHabit(int index) {
    setState(() {
      _habits.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configure Habits"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // --- INPUT SECTION ---
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Habit Name Input
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Habit Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                // 2. Select a Color Label
                const Text(
                  "Select a Color",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),

                // 3. Color Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedColorName,
                      isExpanded: true,
                      items: _colorOptions.keys.map((String name) {
                        return DropdownMenuItem<String>(
                          value: name,
                          child: Row(
                            children: [
                              CircleAvatar(backgroundColor: _colorOptions[name], radius: 10),
                              const SizedBox(width: 10),
                              Text(name),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedColorName = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 4. Add Habit Button
                ElevatedButton(
                  onPressed: _addHabit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text("ADD HABIT", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          const Divider(thickness: 2),

          // --- HABITS LIST SECTION ---
          Expanded(
            child: ListView.builder(
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _habits[index]['color'],
                      radius: 12,
                    ),
                    title: Text(
                      _habits[index]['name'],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteHabit(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}