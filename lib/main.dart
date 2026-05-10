import 'package:flutter/material.dart';

void main() {
  runApp(const HabitTrackerApp());
}

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
  // Mock data to track if habits exist
  final List<String> _habits = []; 
  bool _isSyncing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- 1. TOP NAVIGATION BAR ---
      appBar: AppBar(
        centerTitle: true,
        // Title or loading status
        title: _isSyncing 
          ? const Text("Syncing...", style: TextStyle(fontSize: 18)) 
          : const Text("To Do"),
        
        // Hamburger menu icon (opens the drawer)
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        
        // Settings/Profile icon
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {
              // Open settings or profile logic
            },
          ),
        ],
      ),

      // --- SIDE MENU (The Drawer) ---
      drawer: const Drawer(
        child: Center(child: Text("Menu Options")),
      ),

      // --- 2. BODY SECTION ---
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Personalized Greeting
              const Text(
                "Hello, Ric!",
                style: TextStyle(
                  fontSize: 32, 
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              
              // Subheading / Description
              const SizedBox(height: 8),
              Text(
                "Ready to crush your goals today?",
                style: TextStyle(
                  fontSize: 16, 
                  color: Colors.grey[600],
                ),
              ),
              
              const SizedBox(height: 40),

              // --- 3. INSTRUCTIONS / PLACEHOLDER ---
              // Shows instructions if list is empty, otherwise shows the content
              Expanded(
                child: _habits.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons. LIGHTBULB_OUTLINE, size: 60, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            const Text(
                              "Use the + button to create some habits!",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Swipe right on an activity to mark as done.",
                              style: TextStyle(fontSize: 14, color: Colors.black38),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _habits.length,
                        itemBuilder: (context, index) => ListTile(title: Text(_habits[index])),
                      ),
              ),
            ],
          ),
        ),
      ),

      // --- 4. FLOATING ACTION BUTTON (FAB) ---
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Logic to add a new habit
          setState(() {
            _habits.add("New