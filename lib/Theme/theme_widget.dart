// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/theme_provider.dart';
// import 'theme_provider.dart';

class ThemedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the theme state
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    // Use the theme state to customize the UI
    return Container(
      color: isDarkMode ? Colors.black : Colors.white,
      child: Text(
        'Themed Widget',
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
