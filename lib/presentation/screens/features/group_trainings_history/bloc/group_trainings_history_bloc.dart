import 'package:fittrack/data/services/group_training_service.dart';
import 'package:fittrack/presentation/screens/features/group_trainings/bloc/group_training_event.dart';
import 'package:fittrack/presentation/screens/features/group_trainings/bloc/group_training_state.dart';
import 'package:fittrack/presentation/screens/features/group_trainings_history/bloc/group_trainings_history_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/models/group_training.dart';
import 'group_trainings_history_state.dart';

class GroupTrainingsHistoryBloc extends Bloc<GroupTrainingsHistoryEvent, GroupTrainingHistoryState> {
  final GroupTrainingService _groupTrainingService;

  GroupTrainingsHistoryBloc({required GroupTrainingService groupService}) : _groupTrainingService = groupService, super(GroupTrainingHistoryInitial()) {
    on<GetGroupTrainingsByUser>(_onGetGroupTrainingsByUser);
  }

  Future<void> _onGetGroupTrainingsByUser(
      GetGroupTrainingsByUser event,
      Emitter<GroupTrainingHistoryState> emit,
      ) async {
    emit(GroupTrainingHistoryLoading());
    try {

      final List<GroupTraining> trainings = await _groupTrainingService.fetchUserTrainingHistory();

      emit(GroupTrainingHistoryLoaded(
        groupTrainings: trainings,
      ));
    }
    catch(e){
      emit(GroupTrainingHistoryError(message: e.toString()));
    }
  }
}
