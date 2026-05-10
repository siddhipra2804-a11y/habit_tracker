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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
           ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () => Navigator.pop(context), // Fixed
            )   
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