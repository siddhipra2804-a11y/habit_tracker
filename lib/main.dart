import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true),
    home: HabitTrackerScreen(),
  ));
}

// --- 1. MAIN DASHBOARD ---
class HabitTrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Habit Tracker", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade700,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.shade700),
              child: const Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Configure Habits"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ConfigureHabitsScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Personal Info"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalInfoScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text("Weekly Reports"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => WeeklyReportScreen()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Sign Out", style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: const Center(child: Text("Select an option from the menu")),
    );
  }
}

// --- 2. PERSONAL INFO SCREEN ---
class PersonalInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Personal Info")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: "Name")),
            const TextField(decoration: InputDecoration(labelText: "Username")),
            const TextField(decoration: InputDecoration(labelText: "Age")),
            const TextField(decoration: InputDecoration(labelText: "Country")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {}, 
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
              child: const Text("Save Changes"),
            )
          ],
        ),
      ),
    );
  }
}

// --- 3. WEEKLY REPORT SCREEN ---
class WeeklyReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weekly Reports")),
      body: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Habit')),
            DataColumn(label: Text('Mon')),
            DataColumn(label: Text('Tue')),
            DataColumn(label: Text('Wed')),
          ],
          rows: const [
            DataRow(cells: [
              DataCell(Text('Wake up early')),
              DataCell(Icon(Icons.check_circle, color: Colors.green)),
              DataCell(Icon(Icons.check_circle, color: Colors.green)),
              DataCell(Icon(Icons.radio_button_unchecked)),
            ]),
          ],
        ),
      ),
    );
  }
}

// --- 4. CONFIGURE HABITS SCREEN ---
class ConfigureHabitsScreen extends StatefulWidget {
  @override
  _ConfigureHabitsScreenState createState() => _ConfigureHabitsScreenState();
}

class _ConfigureHabitsScreenState extends State<ConfigureHabitsScreen> {
  String selectedColor = 'Green';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configure Habits")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: "Habit Name")),
            DropdownButton<String>(
              value: selectedColor,
              isExpanded: true,
              items: <String>['Green', 'Orange', 'Blue', 'Red'].map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (val) => setState(() => selectedColor = val!),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () {}, child: const Text("Add Habit")),
            const Divider(height: 40),
            // Habit List Item 1
            ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.green, radius: 10),
              title: const Text("Wake up early"),
              trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {}),
            ),
            // Habit List Item 2
            ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.orange, radius: 10),
              title: const Text("Meditate"),
              trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}