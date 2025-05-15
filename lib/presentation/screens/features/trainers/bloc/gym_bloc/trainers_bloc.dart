import 'package:fittrack/data/services/gym_service.dart';
import 'package:fittrack/presentation/screens/features/gym/bloc/gym_bloc/gym_event.dart';
import 'package:fittrack/presentation/screens/features/gym/bloc/gym_bloc/gym_state.dart';
import 'package:fittrack/presentation/screens/features/trainers/bloc/gym_bloc/trainers_event.dart';
import 'package:fittrack/presentation/screens/features/trainers/bloc/gym_bloc/trainers_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../data/services/trainers_service.dart';

class TrainersBloc extends Bloc<TrainersEvent, TrainersState> {
  final TrainerService _trainerService;

  TrainersBloc({required TrainerService trainerService}) : _trainerService = trainerService, super(TrainersInitial()) {
    on<GetAllTrainersByGymId>(_onGetAllTrainersByGymId);
  }

  Future<void> _onGetAllTrainersByGymId(
      GetAllTrainersByGymId event,
      Emitter<TrainersState> emit,
      ) async {
    emit(TrainersLoading());
    try {

      var trainers = await _trainerService.getTrainersByGymId(event.gymId);

      emit(TrainersLoaded(
        trainers: trainers,
      ));
    }
    catch(e){
      emit(TrainersError(message: e.toString()));
    }
  }
}
