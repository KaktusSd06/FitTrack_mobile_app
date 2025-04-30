import 'package:flutter/material.dart';

const Color white = Color(0xFFFFFFFF);
const Color gray1 = Color(0xFFF9F9F9);
const Color gray2 = Color(0xFFE1E1E1);
const Color gray3 = Color(0xFFC7C7C7);
const Color gray4 = Color(0xFFACACAC);
const Color gray5 = Color(0xFF8C8C8C);
const Color gray6 = Color(0xFF5F5F5F);
const Color fulvous = Color(0xFFE48100);
const Color lightBlue = Color(0xFFC6DFFF);
const Color black = Color(0xFF000000);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color(0xFFE48100),
  hintColor: Color(0xFFC6C1B9),
  scaffoldBackgroundColor: Color(0xFFFFFFFF),
  cardColor: Color(0xFFF9F9F9),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: Color(0xFFE48100),
  ),

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
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: Color(0xFFE48100),
  ),
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
