import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:hisham_todo/firebase_options.dart';
import 'package:hisham_todo/splash_screen.dart';
import 'Controller/Login_page_controller.dart';
import 'Providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Your App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness:
                  themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
            ),
            home: SplashScreen(),
            routes: {
              '/next_screen': (context) => LoginPage(),
            },
          );
        },
      ),
    );
  }
}var currentuser = FirebaseAuth.instance.currentUser;   