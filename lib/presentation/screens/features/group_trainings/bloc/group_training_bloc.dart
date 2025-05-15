import 'package:fittrack/data/services/group_training_service.dart';
import 'package:fittrack/presentation/screens/features/group_trainings/bloc/group_training_event.dart';
import 'package:fittrack/presentation/screens/features/group_trainings/bloc/group_training_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/models/group_training.dart';

class GroupTrainingBloc extends Bloc<GroupTrainingEvent, GroupTrainingState> {
final GroupTrainingService _groupTrainingService;
  
  GroupTrainingBloc({required GroupTrainingService groupService}) : _groupTrainingService = groupService, super(GroupTrainingInitial()) {
    on<GetGroupTrainingsByDate>(_onGetGroupTrainingByDate);
  }

  Future<void> _onGetGroupTrainingByDate(
      GetGroupTrainingsByDate event,
      Emitter<GroupTrainingState> emit,
      ) async {
    emit(GroupTrainingLoading());
    try {

      final List<GroupTraining> trainings = await _groupTrainingService.fetchTrainingsByGymAndPeriod(gymId: event.gymId, fromDate: event.date.toString(), toDate: event.date.toString());

      emit(GroupTrainingLoaded(
        groupTrainings: trainings,
      ));
    }
    catch(e){
      emit(GroupTrainingError(message: e.toString()));
    }
  }
}
