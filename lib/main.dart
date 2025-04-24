import 'package:fittrack/core/config/theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitTrack',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
      systemNavigationBarColor:
      brightness == Brightness.light ? Colors.white : Colors.black,
      systemNavigationBarIconBrightness: brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
    ));

    return Scaffold(
      body: Center(
        child: Text("Hello, Flutter!"),
      ),
    );
  }
}