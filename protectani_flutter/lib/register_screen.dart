import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:protectani_flutter/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  User user = User("", "", "", 0);
  String url = "http://localhost:8080/register";

  Future save() async {
    var res = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({
        'email': user.email,
        'password': user.password,
        'name': user.name,
        'points': 0
      }),
    );

    if (res.statusCode == 200) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(230, 120, 82, 1),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(80),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),
                      Center(
                        child: Text(
                          "Register",
                          style: GoogleFonts.pacifico(
                            fontWeight: FontWeight.w600,
                            fontSize: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Email",
                        style: GoogleFonts.notoSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                        ),
                      ),
                      TextFormField(
                        controller: TextEditingController(text: user.email),
                        onChanged: (val) {
                          user.email = val;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is empty';
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: 15, color: Colors.white),
                        decoration: InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                      Divider(
                        thickness: 2,
                        color: Color.fromRGBO(255, 255, 255, 0.4),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Password",
                        style: GoogleFonts.notoSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: TextEditingController(text: user.password),
                        onChanged: (val) {
                          user.password = val;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is empty';
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: 15, color: Colors.white),
                        decoration: InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                      Divider(
                        thickness: 2,
                        color: Color.fromRGBO(255, 255, 255, 0.4),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Nickname",
                        style: GoogleFonts.notoSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                        ),
                      ),
                      TextFormField(
                        controller: TextEditingController(text: user.name),
                        onChanged: (val) {
                          user.name = val;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is empty';
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: 15, color: Colors.white),
                        decoration: InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                      Divider(
                        thickness: 2,
                        color: Color.fromRGBO(255, 255, 255, 0.4),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Already have Account?",
                            style: GoogleFonts.notoSans(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 70,
                width: 70,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      save();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    backgroundColor: Color.fromRGBO(230, 120, 82, 1),
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
