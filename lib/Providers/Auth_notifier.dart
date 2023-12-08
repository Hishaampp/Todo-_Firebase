import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthNotifier with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _currentUser;

  User? get currentUser => _currentUser;

  AuthNotifier() {
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  Future<void> signIn() async {
    // Implement your sign-in logic here
    try {
      // Example: Sign in with email and password
      await _auth.signInWithEmailAndPassword(
        email: 'example@example.com',
        password: 'password',
      );
    } catch (e) {
      // Handle sign-in errors
      print("Error signing in: $e");
    }
  }

  Future<void> signOut() async {
    // Implement your sign-out logic here
    try {
      await _auth.signOut();
    } catch (e) {
      // Handle sign-out errors
      print("Error signing out: $e");
    }
  }
}
  