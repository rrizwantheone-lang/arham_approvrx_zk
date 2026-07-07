// app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF00796B); // Medical Primary Color
  static const Color secondaryColor = Color(0xFF004D40);
  static const Color bgColor = Color.fromARGB(255, 255, 255, 255);

  static final ThemeData themeData = ThemeData(
    primaryColor: primaryColor,
    hintColor: secondaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      //color: primaryColor,
      backgroundColor: primaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black54),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.teal,
      // Cursor color
      selectionColor: Colors.teal.withValues(alpha: 0.5),
      // Text selection highlight color
      selectionHandleColor: Colors.teal, // Handle color
    ),
  );
}
