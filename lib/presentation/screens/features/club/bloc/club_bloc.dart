import 'package:fittrack/data/models/gym_model.dart';
import 'package:fittrack/data/models/trainer_model.dart';
import 'package:fittrack/data/services/gym_service.dart';
import 'package:fittrack/data/services/user_service.dart';
import 'package:fittrack/presentation/screens/features/club/bloc/club_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'club_event.dart';

class ClubBloc extends Bloc<ClubEvent, ClubState> {
  final GymService _gymService;
  final UserService _userService;

  ClubBloc({required GymService gymService, required UserService userService}) : 
        _gymService = gymService, 
        _userService = userService,  
        super(ClubInitial()) {
    on<GetClubInfo>(_onGetClubInfo);
  }

  Future<void> _onGetClubInfo(GetClubInfo event,
      Emitter<ClubState> emit,) async {
    emit(ClubLoading());
    try {

      GymModel? gym = await _userService.getGymByUserId();
      TrainerModel? trainer = await _userService.getTrainerByUserId();

      emit(ClubLoaded(
          gym: gym,
          membershipTitle: "Річний безлім",
          membershipDate: "12 місяців",
          trainer: trainer,
      ));
    }
    catch(e){
      emit(ClubError(message: e.toString()));
    }
  }
}
