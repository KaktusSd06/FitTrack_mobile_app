import 'package:firebase_core/firebase_core.dart';
import 'package:fittrack/core/config/secure_storage_keys.dart';
import 'package:fittrack/core/config/theme.dart';
import 'package:fittrack/presentation/screens/features/profile/bloc/profile_bloc.dart';
import 'package:fittrack/presentation/screens/features/sign_in/bloc/sign_in_bloc.dart';
import 'package:fittrack/presentation/screens/features/sign_in/sign_in_screen.dart';
import 'package:fittrack/presentation/screens/home_screen.dart';
import 'package:fittrack/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SignInBloc()),
        BlocProvider(create: (_) => ProfileBloc())
      ],
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
              return splash();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Помилка завантаження'));
            } else {
              return snapshot.data ?? SignInScreen();
            }
          },
        ),
      ),
    ),
  );
}

Widget splash() {
  return SplashScreen();
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _textOpacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width, // Явно встановлюємо повну ширину екрана
        height: MediaQuery.of(context).size.height, // Явно встановлюємо повну висоту екрана
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFFE48100),
              Color(0xFFFF9424),
              Color(0xFFFFAA42),
            ],
          ),
        ),
        child: Center( // Центруємо вміст по горизонталі та вертикалі
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Важливо для центрування по горизонталі
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
                  "assets/icon_white.png",
                  width: 180,
                  height: 180,
                ),
              ),
              const SizedBox(height: 32),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textOpacityAnimation.value,
                    child: child,
                  );
                },
                child: Column(
                  children: [
                    Text(
                      "FitTrack",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Шлях до кращої версії себе",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Widget> checkLoggedInStatus() async {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final idToken = await _secureStorage.read(key: SecureStorageKeys.idToken);
  final AuthService _authService = AuthService();

  if (idToken != null) {
    final storedDateStr = await _secureStorage.read(key: SecureStorageKeys.refreshTokenDate);

    if (storedDateStr != null) {
      final storedDate = DateTime.tryParse(storedDateStr);
      final now = DateTime.now();

      if (storedDate != null && now.difference(storedDate).inDays > 7) {
        await _authService.signOut();
      }
    }

    try {
      final authService = AuthService();
      await authService.refreshTokenIfNeeded();
    } catch (e) {
      print("Помилка при оновленні токена: $e");
      await _authService.signOut();
    }

    return HomeScreen();
  } else {
    return SignInScreen();
  }
}