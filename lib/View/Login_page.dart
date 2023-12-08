import 'package:flutter/material.dart';

class LoginPageView extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onEmailPasswordSignIn;
  final VoidCallback onGoogleSignIn;

  LoginPageView({
    required this.emailController,
    required this.passwordController,
    required this.onEmailPasswordSignIn,
    required this.onGoogleSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true, // Add this line
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ... (your existing UI code)

                ElevatedButton(
                  onPressed: onEmailPasswordSignIn,
                  child: Text('Submit'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton.icon(
                  onPressed: onGoogleSignIn,
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
                    primary: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
