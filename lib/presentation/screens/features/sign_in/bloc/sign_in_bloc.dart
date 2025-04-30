import 'package:fittrack/presentation/screens/features/sign_in/bloc/sign_in_event.dart';
import 'package:fittrack/presentation/screens/features/sign_in/bloc/sign_in_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../services/auth_service.dart';
import '../../../home_screen.dart';
import '../sign_in_screen.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthService _authService = AuthService();

  SignInBloc() : super(SignInInitial()) {
    on<SignInWithGoogle>((event, emit) => _onSignInWithGoogle(event, emit));
    on<ShowTermError>(_onShowTermError);
    on<ClearTermError>(_onClearTermError);
    on<SignOutEvent>(_onSignOut);
  }

  Future<void> _onSignInWithGoogle(SignInWithGoogle event, Emitter<SignInState> emit) async {
    emit(SignInLoading());

    try {
      final user = await _authService.signInWithGoogle();

      if (user != null) {
        Navigator.pushReplacement(
          event.context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        emit(const SignInFailure(errorMessage: "Не вдалося авторизуватися"));
      }
    } catch (e) {
      emit(SignInFailure(errorMessage: "Сталася помилка: $e"));
    }
  }

  void _onShowTermError(ShowTermError event, Emitter<SignInState> emit) {
    emit(SignInTermError());
  }

  void _onClearTermError(ClearTermError event, Emitter<SignInState> emit) {
    emit(SignInInitial());
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<SignInState> emit) async {
    try {
      await _authService.signOut();

      emit(SignInInitial());

      Navigator.pushReplacement(
        event.context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    } catch (e) {
      emit(SignInFailure(errorMessage: "Помилка під час виходу: $e"));
    }
  }
}