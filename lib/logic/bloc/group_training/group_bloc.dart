import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/group_training_service.dart';
import 'group_event.dart';
import 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupTrainingService _groupTrainingService;

  GroupBloc({required GroupTrainingService groupTrainingService})
      : _groupTrainingService = groupTrainingService,
        super(GroupInitial()) {

    on<AddUserToGroupTraining>(_onAddUserToGroupTraining);
  }

  Future<void> _onAddUserToGroupTraining(
      AddUserToGroupTraining event,
      Emitter<GroupState> emit,
      ) async {
    try {
      emit(GroupLoading());

      await _groupTrainingService.assignUserToTraining(
        trainingId: event.trainingId,
      );

      emit(const GroupLoaded());
    } catch (e) {
      emit(GroupError(message: e.toString()));
    }
  }
}