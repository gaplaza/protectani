import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:protectani_flutter/main_screen.dart';
import 'package:protectani_flutter/register_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String url = "http://localhost:8080/login";

  Future save() async {
    if (_formKey.currentState!.validate()) {
      var res = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode({
            'email': emailController.text,
            'password': passwordController.text
          }));

      if (res.statusCode == 200) {
        final userData = json.decode(res.body);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MainScreen(email: userData['email'], userId: userData['id']),
          ),
        );
      } else {
        print("Login failed: ${res.statusCode}");
      }
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
                height: MediaQuery.of(context).size.height * 0.7,
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
                          "Login",
                          style: GoogleFonts.pacifico(
                              fontWeight: FontWeight.w600,
                              fontSize: 50,
                              color: Colors.white),
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
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is empty';
                          }
                          final RegExp emailRegex = RegExp(
                              r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Invalid email format';
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: 15, color: Colors.white),
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
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
                        controller: passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is empty';
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: 15, color: Colors.white),
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()));
                          },
                          child: Text(
                            "Don't have Account?",
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
                    save();
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
