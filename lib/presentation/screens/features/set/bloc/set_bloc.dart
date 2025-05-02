import 'package:fittrack/presentation/screens/features/set/bloc/set_event.dart';
import 'package:fittrack/presentation/screens/features/set/bloc/set_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/services/exercise_service.dart';
import '../../../../../data/services/set_service.dart';

class SetBloc extends Bloc<SetEvent, SetState> {
  final ExerciseService _exerciseService;
  final SetService _setService;

  SetBloc({
    required ExerciseService exerciseService,
    required SetService setService,
  })  : _exerciseService = exerciseService,
        _setService = setService,
        super(SetInitial()) {
    on<LoadExercise>(_onLoadExercise);
    on<LoadSets>(_onLoadSets);
    on<AddSet>(_onAddSet);
    on<DeleteSet>(_onDeleteSet);
  }

  Future<void> _onLoadExercise(LoadExercise event, Emitter<SetState> emit) async {
    try {
      emit(SetLoading());
      final exercise = await _exerciseService.getExerciseById(event.exerciseId);
      emit(ExerciseLoaded(exercise));
    } catch (e) {
      emit(SetFailure('Не вдалося завантажити вправу: $e'));
    }
  }

  Future<void> _onLoadSets(LoadSets event, Emitter<SetState> emit) async {
    try {
      emit(SetLoading());
      final sets = await _setService.getSetsByIndividualTrainingId(event.individualTrainingId);
      emit(SetsLoaded(sets));
    } catch (e) {
      emit(SetFailure('Не вдалося завантажити сети: $e'));
    }
  }

  Future<void> _onAddSet(AddSet event, Emitter<SetState> emit) async {
    try {
      emit(SetLoading());
      final createdSet = await _setService.createSet(event.set);
      if (createdSet != null) {
        emit(SetAdded(createdSet));
      } else {
        emit(const SetFailure('Не вдалося створити сет'));
      }
    } catch (e) {
      emit(SetFailure('Помилка при створенні сету: $e'));
    }
  }

  Future<void> _onDeleteSet(DeleteSet event, Emitter<SetState> emit) async {
    try {
      emit(SetLoading());
      final success = await _setService.deleteSet(event.setId);
      if (success) {
        emit(SetDeleted(event.setId));
      } else {
        emit(const SetFailure('Не вдалося видалити сет'));
      }
    } catch (e) {
      emit(SetFailure('Помилка при видаленні сету: $e'));
    }
  }
}