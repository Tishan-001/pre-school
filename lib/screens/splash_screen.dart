import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pre_school/screens/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LogInScreen())); // Navigate to main screen after 3 seconds.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set your desired background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Your logo widget here.
            Image.asset('assets/logo1.png', width: 200, height: 200), // Replace with your assets image path
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
