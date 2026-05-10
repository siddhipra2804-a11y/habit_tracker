class Activity {
  final String id;
  final String name;
  bool isSelected;

  Activity({required this.id, required this.name, this.isSelected = false});
}

class UserProfile {
  final String username;
  final List<Activity> selectedActivities;

  UserProfile({required this.username, required this.selectedActivities});
}