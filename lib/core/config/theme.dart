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
  scaffoldBackgroundColor: white,
  cardColor: gray1,
  hintColor: const Color(0xFFC6C1B9),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: fulvous),
  colorScheme: ColorScheme.light(
    primary: fulvous,
    secondary: gray4,
    background: white,
    surface: gray1,
    onPrimary: white,
    onSecondary: black,
    onBackground: black,
    onSurface: black,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    displaySmall: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    headlineMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    headlineSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: black,
  cardColor: const Color(0xFF201F1C),
  hintColor: const Color(0xFF4A4A47),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: fulvous),
  colorScheme: ColorScheme.dark(
    primary: fulvous,
    secondary: gray4,
    background: black,
    surface: gray6,
    onPrimary: black,
    onSecondary: black,
    onBackground: white,
    onSurface: white,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    displaySmall: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    headlineMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    headlineSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
  ),
);

