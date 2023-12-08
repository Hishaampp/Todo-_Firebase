
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


import '../Screens/Home_screen.dart';


// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 100,),
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/life store.png'),
                      radius: 70,
                    ),
                  ),
                ],
              ),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                icon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                icon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () async {
                await _signInWithEmailPassword(context);
              },
              child: Text('Submit'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () async {
                await _signInWithGoogle(context);
              },
              icon: Image.asset(
                'assets/YouTube Google Logo Google S Google Account PNG - Free Download.jpeg',
                height: 24.0,
                width: 24.0,
              ),
              label: Text(
                'Continue with Google',
                style: TextStyle(
                  color: Colors.transparent.withOpacity(0.5),
                ),
              ),
              style: ElevatedButton.styleFrom(
                // ignore: deprecated_member_use
                primary: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signInWithEmailPassword(BuildContext context) async {
    try {
      String email = emailController.text;
      String password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        return;
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to the home page after successful email/password Sign-In
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      // ignore: avoid_print
      print("Error signing in with Email/Password: $e");
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to the home page after successful Google Sign-In
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      // ignore: avoid_print
      print("Error signing in with Google: $e");
    }
  }
}
