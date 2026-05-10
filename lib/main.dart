import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(),
      ),
    ),
  );
}

// 1. STATE MANAGEMENT
class UserProvider extends ChangeNotifier {
  // Registration Fields
  String _name = "";
  String _username = "";
  int _age = 0;
  String _country = "";
  
  bool _isLoggedIn = false;
  bool _isConfigured = false;

  // Habit Maps
  Map<String, dynamic> _selectedHabitsMap = {};
  Map<String, dynamic> _completedHabitsMap = {};

  // Getters
  String get username => _username;
  bool get isLoggedIn => _isLoggedIn;
  bool get isConfigured => _isConfigured;
  Map<String, dynamic> get selectedHabitsMap => _selectedHabitsMap;

  UserProvider() {
    _loadFromLocalStorage();
  }

  // --- LOCAL STORAGE CORE LOGIC ---
  Future<void> _loadFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('name') ?? "";
    _username = prefs.getString('username') ?? "";
    _age = prefs.getInt('age') ?? 0;
    _country = prefs.getString('country') ?? "";
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _isConfigured = prefs.getBool('isConfigured') ?? false;

    // Load Maps
    _selectedHabitsMap = jsonDecode(prefs.getString('selectedHabitsMap') ?? "{}");
    _completedHabitsMap = jsonDecode(prefs.getString('completedHabitsMap') ?? "{}");

    notifyListeners();
  }

  Future<void> _syncStorage() async {
    final prefs = await SharedPreferences.getInstance();
    // Save Registration Info
    await prefs.setString('name', _name);
    await prefs.setString('username', _username);
    await prefs.setInt('age', _age);
    await prefs.setString('country', _country);
    
    // Save App State
    await prefs.setBool('isLoggedIn', _isLoggedIn);
    await prefs.setBool('isConfigured', _isConfigured);
    
    // Save Habit Maps
    await prefs.setString('selectedHabitsMap', jsonEncode(_selectedHabitsMap));
    await prefs.setString('completedHabitsMap', jsonEncode(_completedHabitsMap));
  }

  // --- ACTIONS ---
  void registerUser(String name, String user, int age, String country) {
    _name = name;
    _username = user;
    _age = age;
    _country = country;
    _isLoggedIn = true;
    _syncStorage(); // Pushes to Local Storage immediately
    notifyListeners();
  }

  void addHabit(String habitName, Color color) {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    _selectedHabitsMap[id] = {
      'name': habitName,
      'color': color.value.toRadixString(16),
    };
    _syncStorage();
    notifyListeners();
  }

  void completeHabit(String id) {
    if (_selectedHabitsMap.containsKey(id)) {
      _completedHabitsMap[id] = _selectedHabitsMap[id];
      _selectedHabitsMap.remove(id);
      _syncStorage();
      notifyListeners();
    }
  }

  void finishSetup() {
    _isConfigured = true;
    _syncStorage();
    notifyListeners();
  }

  void logout() async {
    _isLoggedIn = false;
    _isConfigured = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears Local Storage on logout
    notifyListeners();
  }
}

// 2. AUTH WRAPPER (Switches Screens)
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    if (!user.isLoggedIn) return const RegistrationScreen();
    if (!user.isConfigured) return const ConfigureHabitsScreen();
    return const DailyActivityScreen();
  }
}

// 3. REGISTRATION SCREEN
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _userController = TextEditingController();
  final _ageController = TextEditingController();
  final _countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Registration")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Full Name")),
            TextField(controller: _userController, decoration: const InputDecoration(labelText: "Username")),
            TextField(controller: _ageController, decoration: const InputDecoration(labelText: "Age"), keyboardType: TextInputType.number),
            TextField(controller: _countryController, decoration: const InputDecoration(labelText: "Country")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<UserProvider>().registerUser(
                  _nameController.text, 
                  _userController.text, 
                  int.tryParse(_ageController.text) ?? 0, 
                  _countryController.text
                );
              },
              child: const Text("Register & Save to Local Storage"),
            )
          ],
        ),
      ),
    );
  }
}

// 4. CONFIGURE HABITS SCREEN
class ConfigureHabitsScreen extends StatefulWidget {
  const ConfigureHabitsScreen({super.key});
  @override
  State<ConfigureHabitsScreen> createState() => _ConfigureHabitsScreenState();
}

class _ConfigureHabitsScreenState extends State<ConfigureHabitsScreen> {
  final _habitCtrl = TextEditingController();
  Color _selectedColor = Colors.yellow;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text("Step 2: Add Habits")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(controller: _habitCtrl, decoration: const InputDecoration(labelText: "Habit Name")),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Colors.yellow, Colors.blue, Colors.green, Colors.red].map((c) => IconButton(
              icon: Icon(Icons.circle, color: c, size: _selectedColor == c ? 40 : 25),
              onPressed: () => setState(() => _selectedColor = c),
            )).toList(),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<UserProvider>().addHabit(_habitCtrl.text, _selectedColor);
              _habitCtrl.clear();
            },
            child: const Text("Add Habit to Map"),
          ),
          Expanded(
            child: ListView(
              children: user.selectedHabitsMap.entries.map((e) => ListTile(
                leading: CircleAvatar(backgroundColor: Color(int.parse("0x${e.value['color']}"))),
                title: Text(e.value['name']),
              )).toList(),
            ),
          ),
          ElevatedButton(onPressed: () => user.finishSetup(), child: const Text("Finish Configuration")),
        ],
      ),
    );
  }
}

// 5. DAILY ACTIVITY SCREEN
class DailyActivityScreen extends StatelessWidget {
  const DailyActivityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard: ${user.username}"),
        actions: [IconButton(icon: const Icon(Icons.logout), onPressed: () => user.logout())],
      ),
      body: ListView(
        children: user.selectedHabitsMap.entries.map((e) => ListTile(
          title: Text(e.value['name']),
          trailing: IconButton(icon: const Icon(Icons.check), onPressed: () => user.completeHabit(e.key)),
        )).toList(),
      ),
    );
  }
}