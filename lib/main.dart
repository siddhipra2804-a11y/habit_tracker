import 'package:flutter/material.dart';

void main() {
  runApp(const HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  // Toggle this to see how the title changes based on app status
  bool _isLoading = false; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- TOP NAVIGATION BAR ---
      appBar: AppBar(
        // 1. Title or Loading Status
        title: _isLoading 
            ? const Text("Syncing...") 
            : const Text("To Do"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        
        // 2. Hamburger Menu Icon (Implicit)
        // Note: Because we have a 'drawer' below, Flutter 
        // automatically creates the menu icon on the left.

        // 3. Settings/Profile Icon
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Profile Settings',
            onPressed: () {
              // Action for settings
              print("Settings opened");
            },
          ),
        ],
      ),

      // --- SIDE MENU (Hamburger Content) ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onPressed: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('History'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Your Habit List View will go here"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => setState(() => _isLoading = !_isLoading),
              child: Text(_isLoading ? "Show Title" : "Show Loading Status"),
            )
          ],
        ),
      ),
    );
  }
}