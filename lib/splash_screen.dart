// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _greeting = '';

  @override
  void initState() {
    super.initState();
    _setGreeting();
    _navigateToNextScreen();
  }

  void _setGreeting() {
    var now = DateTime.now();
    var formatter = DateFormat('H');
    var hour = int.parse(formatter.format(now));

    if (hour >= 5 && hour < 12) {
      _greeting = 'Good Morning';
    } else if (hour >= 12 && hour < 18) {
      _greeting = 'Good Afternoon';
    } else {
      _greeting = 'Good Night';
    }
  }

  void _navigateToNextScreen() {
    Future.delayed(Duration(seconds: 3), () {
      // Navigate to the next screen (replace 'NextScreen' with your screen)
      Navigator.pushReplacementNamed(context, '/next_screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/life store.png', width: 100, height: 100),
            SizedBox(height: 20),
            Text(
              _greeting,
             
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
