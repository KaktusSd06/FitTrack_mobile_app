import 'package:firebase_core/firebase_core.dart';
import 'package:fittrack/core/config/secure_storage_keys.dart';
import 'package:fittrack/core/config/theme.dart';
import 'package:fittrack/presentation/screens/features/sign_in/sign_in_screen.dart';
import 'package:fittrack/presentation/screens/features/splash_screen/splash.dart';
import 'package:fittrack/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'app_bloc_providers.dart';
import 'data/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    AppBlocs.provideBlocsToApp(
      child: MaterialApp(
        title: 'FitTrack',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<Widget>(
          future: checkLoggedInStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Помилка завантаження'));
            } else {
              return snapshot.data ?? const SignInScreen();
            }
          },
        ),
      ),
    ),
  );
}

Future<Widget> checkLoggedInStatus() async {
  const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final idToken = await secureStorage.read(key: SecureStorageKeys.idToken);
  final AuthService authService0 = AuthService();

  if (idToken != null) {
    final storedDateStr = await secureStorage.read(key: SecureStorageKeys.refreshTokenDate);

    if (storedDateStr != null) {
      final storedDate = DateTime.tryParse(storedDateStr);
      final now = DateTime.now();

      if (storedDate != null && now.difference(storedDate).inDays > 7) {
        await authService0.signOut();
      }
    }

    try {
      final authService = AuthService();
      await authService.refreshTokenIfNeeded();
    } catch (e) {
      await authService0.signOut();
    }

    return const HomeScreen();
  } else {
    return const SignInScreen();
  }
}