import 'package:firebase_core/firebase_core.dart';
import 'package:fittrack/core/config/secure_storage_keys.dart';
import 'package:fittrack/core/config/theme.dart';
import 'package:fittrack/data/services/goal_service.dart';
import 'package:fittrack/data/services/meal_service.dart';
import 'package:fittrack/data/services/weight_service.dart';
import 'package:fittrack/presentation/screens/features/goal/bloc/goal_bloc.dart';
import 'package:fittrack/presentation/screens/features/individual_training/bloc/individual_training_bloc.dart';
import 'package:fittrack/presentation/screens/features/meal/bloc/meal_bloc.dart';
import 'package:fittrack/presentation/screens/features/meal/chart/bloc/meal_chart_bloc.dart';
import 'package:fittrack/presentation/screens/features/page_with_indicators/bloc/page_with_indicators_bloc.dart';
import 'package:fittrack/presentation/screens/features/profile/bloc/profile_bloc.dart';
import 'package:fittrack/presentation/screens/features/set/bloc/set_bloc.dart';
import 'package:fittrack/presentation/screens/features/sign_in/bloc/sign_in_bloc.dart';
import 'package:fittrack/presentation/screens/features/sign_in/sign_in_screen.dart';
import 'package:fittrack/presentation/screens/features/weight/bloc/weight_bloc.dart';
import 'package:fittrack/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';

import 'data/services/auth_service.dart';
import 'data/services/calories_statistics_service.dart';
import 'data/services/exercise_service.dart';
import 'data/services/individual_training_service.dart';
import 'data/services/set_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SignInBloc()),
        BlocProvider(create: (_) => ProfileBloc()),
        BlocProvider(
          create: (context) =>
              IndividualTrainingBloc(
                trainingService: IndividualTrainingService(
                ),
              ),
        ),
        BlocProvider<SetBloc>(
          create: (context) => SetBloc(
            exerciseService: ExerciseService(),
            setService: SetService(),
          ),
        ),
        BlocProvider<PageWithIndicatorsBloc>(
          create: (context) => PageWithIndicatorsBloc(
            mealService: MealService(),
            goalService: GoalService(),
            weightModel: WeightService(),
          ),
        ),
        BlocProvider<MealBloc>(
          create: (context) => MealBloc(
            mealService: MealService(),
            goalService: GoalService(),
          ),
        ),
        BlocProvider<GoalBloc>(
          create: (context) => GoalBloc(
            goalService: GoalService(),
          ),
        ),
        BlocProvider<WeightBloc>(
          create: (context) => WeightBloc(
            weightService: WeightService(),
          ),
        ),
        BlocProvider<MealChartBloc>(
          create: (context) => MealChartBloc(
            statisticsService: CaloriesStatisticsService(),
          ),
        ),
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
              return snapshot.data ?? const SignInScreen();
            }
          },
        ),
      ),
    ),
  );
}

Widget splash() {
  return const SplashScreen();
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                            color: Colors.black.withAlpha((0.3 * 255).round()),
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
                        color: Colors.white.withAlpha((0.9 * 255).round()),
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