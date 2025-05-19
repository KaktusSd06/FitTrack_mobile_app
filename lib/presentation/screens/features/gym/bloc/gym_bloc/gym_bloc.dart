import 'package:fittrack/data/services/gym_service.dart';
import 'package:fittrack/presentation/screens/features/gym/bloc/gym_bloc/gym_event.dart';
import 'package:fittrack/presentation/screens/features/gym/bloc/gym_bloc/gym_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GymBloc extends Bloc<GymEvent, GymState> {
  final GymService _gymService;

  GymBloc({required GymService gymService}) : _gymService = gymService, super(GymInitial()) {
    on<GetAllGyms>(_onGetAllGyms);
  }

  Future<void> _onGetAllGyms(
      GetAllGyms event,
      Emitter<GymState> emit,
      ) async {
    emit(GymLoading());
    try {

      var gyms = await _gymService.fetchGyms();

      emit(GymLoaded(
        gyms: gyms,
      ));
    }
    catch(e){
      emit(GymError(message: e.toString()));
    }
  }
}
