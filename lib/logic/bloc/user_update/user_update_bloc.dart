import 'package:fittrack/logic/bloc/user_update/user_update_event.dart';
import 'package:fittrack/logic/bloc/user_update/user_update_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/user_service.dart';

class UserUpdateBloc extends Bloc<UserUpdateEvent, UserUpdateState> {
  final UserService _userService;

  UserUpdateBloc({required UserService userService})
      : _userService = userService,
        super(UserUpdateInitial()) {
    on<UpdateUserGymEvent>(_onUpdateUserGym);
    on<UpdateUserTrainerEvent>(_onUpdateUserTrainer);
    on<UpdateUserDetailsEvent>(_onUpdateUserDetails);
  }

  Future<void> _onUpdateUserGym(
      UpdateUserGymEvent event,
      Emitter<UserUpdateState> emit,
      ) async {
    emit(UserUpdateLoading());
    try {
      await _userService.patchUserDetails(gymId: event.gymId);
      await _userService.patchUserDetails(trainerId: null);
      emit(UserUpdateSuccess());
    } catch (error) {
      emit(UserUpdateFailure(error.toString()));
    }
  }

  Future<void> _onUpdateUserTrainer(
      UpdateUserTrainerEvent event,
      Emitter<UserUpdateState> emit,
      ) async {
    emit(UserUpdateLoading());
    try {
      await _userService.patchUserDetails(trainerId: event.trainerId);
      emit(UserUpdateSuccess());
    } catch (error) {
      emit(UserUpdateFailure(error.toString()));
    }
  }

  Future<void> _onUpdateUserDetails(
      UpdateUserDetailsEvent event,
      Emitter<UserUpdateState> emit,
      ) async {
    emit(UserUpdateLoading());
    try {
      await _userService.patchUserDetails(
        gymId: event.gymId,
        trainerId: event.trainerId,
      );
      emit(UserUpdateSuccess());
    } catch (error) {
      emit(UserUpdateFailure(error.toString()));
    }
  }
}