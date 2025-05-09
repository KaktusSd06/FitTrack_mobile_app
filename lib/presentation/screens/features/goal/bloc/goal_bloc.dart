import 'package:fittrack/presentation/screens/features/goal/bloc/goal_event.dart';
import 'package:fittrack/presentation/screens/features/goal/bloc/goal_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/services/goal_service.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState>{
  final GoalService _goalService;

  GoalBloc({required GoalService goalService}) :
        _goalService = goalService, super(GoalInitial()){
    on<CreateGoalByType>(_onGoalBloc);
  }

  Future<void> _onGoalBloc(CreateGoalByType event, Emitter<GoalState> emit,) async {
    emit(GoalAdding());

    try {
      await _goalService.setOrUpdateGoal(value: event.value, goalType: event.goalType);
      emit(GoalAdded(goalType: event.goalType, value: event.value));
    }
    catch(e){
      emit(GoalError(message: e.toString()));
    }

  }
}