// ignore_for_file: use_build_context_synchronously, deprecated_member_use, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hisham_todo/Controller/Login_page_controller.dart';
import 'package:provider/provider.dart';
import 'package:hisham_todo/Providers/theme_provider.dart';
import '../Model/Auth.dart';

class SettingsPage extends StatelessWidget {
  final AuthModel authModel;

  SettingsPage({required this.authModel});

  Future<void> _signOut(BuildContext context) async {
    try {
      FirebaseAuth.instance.signOut();
      GoogleSignIn().signOut();
      // await authModel.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signed out successfully.'),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme',
              style: Theme.of(context).textTheme.headline6,
            ),
            SwitchListTile(
              title: Text('Dark Theme'),
              onChanged: (value) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
              value: Provider.of<ThemeProvider>(context).isDarkMode,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _signOut(context);
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
