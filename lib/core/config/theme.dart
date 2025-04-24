import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color(0xFFE48100),
  hintColor: Color(0xFFC6C1B9),
  scaffoldBackgroundColor: Color(0xFFFFFFFF),
  cardColor: Color(0xFFF4F0E9),
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    displaySmall: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    headlineMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    headlineSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xFFE48100),
    textTheme: ButtonTextTheme.primary,
  ),
);

// Define dark theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFFE48100),
  hintColor: Color(0xFF3A3A37),
  scaffoldBackgroundColor: Color(0xFF000000),
  cardColor: Color(0xFF201F1C),
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    displaySmall: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    headlineMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    headlineSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xFFE48100),
    textTheme: ButtonTextTheme.primary,
  ),
);
