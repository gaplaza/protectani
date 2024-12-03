import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:protectani_flutter/userinfo_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainScreen extends StatefulWidget {
  final String email;
  final int userId;

  const MainScreen({
    Key? key,
    required this.email,
    required this.userId,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? selectedActivity;
  List<String> activities = [];
  List<String> userActivities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchActivities();
  }

  Future<void> fetchActivities() async {
    try {
      final url = Uri.parse('http://localhost:8080/api/activities');
      final response = await http.get(url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          activities =
              data.map((activity) => activity['type'] as String).toList();
          isLoading = false;
        });
      } else {
        print('Failed to fetch activities: ${response.body}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching activities: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void addActivity() async {
    if (selectedActivity != null) {
      final url = Uri.parse('http://localhost:8080/api/user-activities');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': widget.userId,
          'activity_type': selectedActivity,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          userActivities.add(selectedActivity!);
        });
      } else {
        print('Failed to add activity: ${response.body}');
      }
    }
  }

  void removeActivity(int index) async {
    final activityToRemove = userActivities[index];

    try {
      final url = Uri.parse('http://localhost:8080/api/user-activities');
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'activityType': activityToRemove,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          userActivities.removeAt(index);
        });
      } else {
        print('Failed to delete activity: ${response.body}');
      }
    } catch (e) {
      print('Error deleting activity: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Activities list: $activities');
    print('Selected activity: $selectedActivity');
    print('Is loading: $isLoading');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(230, 120, 82, 1),
        title: Text("ProtectAni"),
        titleTextStyle: GoogleFonts.pacifico(color: Colors.white, fontSize: 30),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.email}, 환영합니다!",
                        style: TextStyle(fontSize: 18),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserInfoScreen(
                                email: widget.email,
                                userId: widget.userId,
                              ),
                            ),
                          );
                        },
                        child: const Text('내 정보'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          dropdownColor: Colors.white,
                          value: selectedActivity,
                          hint: Text("Select Activity"),
                          isExpanded: true,
                          items: activities.map((String activity) {
                            return DropdownMenuItem<String>(
                              value: activity,
                              child: Text(activity),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              selectedActivity = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: addActivity,
                        child: Text("Add"),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "이번에 추가한 활동:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: userActivities.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(userActivities[index]),
                          trailing: IconButton(
                            icon: Icon(Icons.close),
                            color: Colors.red,
                            onPressed: () => removeActivity(index),
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
