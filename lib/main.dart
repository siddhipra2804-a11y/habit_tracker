import 'package:flutter/material.dart';
import 'package:habit_tracker/screens/daily_activity_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Function to save user profile data
Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userProfile', jsonEncode(profile));
}

// Function to retrieve user profile data
Future<Map<String, dynamic>?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileString = prefs.getString('userProfile');
    return profileString != null ? jsonDecode(profileString) : null;
}

Future<void> saveUserAction(String action) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> actions = prefs.getStringList('userActions') ?? [];
    actions.add(action);
    await prefs.setStringList('userActions', actions);
}


void main() => runApp(const HabitTrackerApp());

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isLoggedIn = false;
  bool isLoginView = true;

  void toggleView() => setState(() => isLoginView = !isLoginView);
  void login() => setState(() => isLoggedIn = true);
  void logout() => setState(() => isLoggedIn = false);

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return DailyActivityScreen(onLogout: logout);
    }
    return isLoginView
        ? LoginScreen(onLogin: login, toRegister: toggleView)
        : RegisterScreen(onRegister: login, toLogin: toggleView);
  }
}

// --- SHARED STYLES ---
Widget _buildInputLabel(String label) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    ),
  );
}

// Custom TextField with White Background for the Box
Widget _buildCustomField({required String hint, bool obscure = false, String? initialValue}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white, // Background of the input box
      borderRadius: BorderRadius.circular(8),
    ),
    child: TextFormField(
      initialValue: initialValue,
      obscureText: obscure,
      style: const TextStyle(color: Colors.black), // Text typed inside is black for readability
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        border: InputBorder.none,
      ),
    ),
  );
}

// --- LOGIN SCREEN ---
class LoginScreen extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback toRegister;

  const LoginScreen({super.key, required this.onLogin, required this.toRegister});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800], // Deep Blue Background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const Text("LOGIN", style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              _buildInputLabel("Username"),
              _buildCustomField(hint: "Enter username"),
              const SizedBox(height: 20),
              _buildInputLabel("Password"),
              _buildCustomField(hint: "Enter password", obscure: true),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: () {}, child: const Text("Forgot Password?", style: TextStyle(color: Colors.white70))),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onLogin,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.blue[800], minimumSize: const Size(double.infinity, 50)),
                child: const Text("LOGIN"),
              ),
              TextButton(onPressed: toRegister, child: const Text("Sign Up", style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
      ),
    );
  }
}

// --- REGISTER SCREEN ---
class RegisterScreen extends StatefulWidget {
  final VoidCallback onRegister;
  final VoidCallback toLogin;
  const RegisterScreen({super.key, required this.onRegister, required this.toLogin});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final List<String> habits = ["Walking", "Gym", "Reading", "Coding", "Meditation"];
  final List<String> selectedHabits = [];
  String? selectedCountry = "USA";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      body: Scrollbar(
        thumbVisibility: true,
        thickness: 8,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Text("REGISTER", style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              _buildInputLabel("Username"),
              _buildCustomField(hint: "Username"),
              const SizedBox(height: 15),
              _buildInputLabel("Password"),
              _buildCustomField(hint: "Password", obscure: true),
              const SizedBox(height: 15),
              _buildInputLabel("Age"),
              _buildCustomField(hint: "Age", initialValue: "25"),
              const SizedBox(height: 15),
              _buildInputLabel("Country"),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCountry,
                    isExpanded: true,
                    items: ["USA", "India", "UK", "Canada"].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) => setState(() => selectedCountry = val),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Text("Select Habits", style: TextStyle(color: Colors.white, fontSize: 18)),
              Wrap(
                spacing: 8,
                children: habits.map((habit) {
                  bool isSelected = selectedHabits.contains(habit);
                  return FilterChip(
                    label: Text(habit),
                    selected: isSelected,
                    selectedColor: Colors.white,
                    checkmarkColor: Colors.blue,
                    onSelected: (val) => setState(() => val ? selectedHabits.add(habit) : selectedHabits.remove(habit)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: widget.onRegister,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.blue[700], minimumSize: const Size(double.infinity, 50)),
                child: const Text("REGISTER"),
              ),
              TextButton(onPressed: widget.toLogin, child: const Text("Already Register? Log In", style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
      ),
    );
  }
}

// --- DAILY ACTIVITY SCREEN ---
class DailyActivitiesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final activities = context.watch<UserProvider>().dailyActivities;

    return activities.isEmpty
        ? Center(child: Text("No activities selected yet!"))
        : ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.check_circle_outline),
                title: Text(activities[index].name),
              );
            },
          );
  }
}

class UserProvider extends ChangeNotifier {
  String _username = "Guest";
  List<Activity> _allActivities = [
    Activity(id: '1', name: 'Morning Run'),
    Activity(id: '2', name: 'Read 10 Pages'),
    Activity(id: '3', name: 'Meditation'),
    Activity(id: '4', name: 'Code Project'),
  ];

  String get username => _username;
  
  // Logic: Only return activities where isSelected is true
  List<Activity> get dailyActivities => 
      _allActivities.where((a) => a.isSelected).toList();

  void registerUser(String name, List<String> selectedIds) {
    _username = name;
    for (var activity in _allActivities) {
      activity.isSelected = selectedIds.contains(activity.id);
    }
    notifyListeners(); // This updates the UI everywhere
  }
}