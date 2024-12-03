import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class UserInfoScreen extends StatefulWidget {
  final int userId;
  final String email;

  const UserInfoScreen({Key? key, required this.userId, required this.email})
      : super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  List<String> userActivities = [];
  int totalPoints = 0;

  @override
  void initState() {
    super.initState();
    fetchUserActivities();
  }

  void fetchUserActivities() async {
    final url =
        Uri.parse('http://localhost:8080/api/user-activities/${widget.userId}');
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      print('User data: ${data['user']}');
      print('Activities: ${data['activities']}');

      setState(() {
        userActivities = (data['activities'] as Map<String, dynamic>)
            .entries
            .map((entry) => '${entry.key} (${entry.value} times)')
            .toList();

        totalPoints = (data['user']['points'] ?? 0) as int;
      });
    } else {
      print('Failed to fetch activities: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Info'),
        backgroundColor: Color.fromRGBO(230, 120, 82, 1),
        titleTextStyle: GoogleFonts.pacifico(color: Colors.white, fontSize: 30),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User: ${widget.email}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Total Points: $totalPoints',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Your Activities:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: userActivities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(userActivities[index]),
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
