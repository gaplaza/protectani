import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainScreen extends StatefulWidget {
  final int userId;
  final String email;
  final String name;

  const MainScreen({
    Key? key,
    required this.userId,
    required this.email,
    required this.name,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? selectedActivity;
  List<Map<String, dynamic>> activities = [];
  int userPoints = 0;

  final List<String> activityTypes = [
    'Shelter Volunteer',
    'Adoption',
  ];

  @override
  void initState() {
    super.initState();
    fetchUserPoints();
    fetchActivities();
  }

  Future<void> fetchUserPoints() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:8080/api/user-activities/points?userId=${widget.userId}'),
      );
      if (response.statusCode == 200) {
        setState(() {
          userPoints = int.parse(response.body);
        });
      }
    } catch (e) {
      print('Error fetching points: $e');
    }
  }

  Future<void> fetchActivities() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/activities'),
      );
      if (response.statusCode == 200) {
        setState(() {
          activities =
              List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      }
    } catch (e) {
      print('Error fetching activities: $e');
    }
  }

  Future<void> addActivity() async {
    if (selectedActivity == null) return;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/user-activities/addActivity'),
        headers: {'Content-Type': 'application/json, charset=UTF-8'},
        body: json.encode({
          'user_id': widget.userId,
          'activity_type': selectedActivity,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activity added successfully')),
        );
        fetchActivities();
        fetchUserPoints();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add activity')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Protected Animal'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Welcome, ${widget.name}!',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.stars, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text(
                          '$userPoints points',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Activity Selection
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Activity',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedActivity,
                    items: activityTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedActivity = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: selectedActivity == null ? null : addActivity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Add Activity'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              'Your Activities',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        activity['type'] == 'Adoption'
                            ? Icons.pets
                            : Icons.volunteer_activism,
                        color: Colors.green,
                      ),
                      title: Text(activity['type']),
                      subtitle: Text(activity['description'] ?? ''),
                      trailing: Text(
                        '${activity['points']} points',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
