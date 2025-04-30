import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../../services/auth_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final AuthService _authService = AuthService();

  ProfileBloc() : super(ProfileLoading()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final account = await _googleSignIn.signInSilently();
        if (account != null) {
          emit(ProfileLoaded(
            displayName: account.displayName,
            photoUrl: account.photoUrl,
          ));
        } else {
          emit(const ProfileError("Користувач не авторизований"));
        }
      } catch (e) {
        emit(ProfileError("Помилка: ${e.toString()}"));
      }
    });

    on<DeleteAccount>((event, emit) async {
      try {
        final account = await _googleSignIn.signInSilently();

        if (account != null) {
          await _authService.deleteAccount(email: account.email);
          emit(AccountDeleted());
        } else {
          emit(const AccountDeletionError("Користувач не авторизований. Увійдіть, щоб видалити акаунт."));
        }
      } catch (e) {
        emit(AccountDeletionError("Не вдалося видалити акаунт"));
      }
    });
  }
}