import 'package:firebase_core/firebase_core.dart';
import 'package:fittrack/core/config/theme.dart';
import 'package:fittrack/presentation/screens/features/sign_in/bloc/sign_in_bloc.dart';
import 'package:fittrack/presentation/screens/features/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SignInBloc()),
      ],
      child: MaterialApp(
        title: 'FitTrack',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: SignInScreen(),
      ),
    ),
  );

}