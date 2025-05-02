import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../data/services/exercise_service.dart';
import 'exercise_event.dart';
import 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final ExerciseService _exerciseService;

  ExerciseBloc({required ExerciseService exerciseService})
      : _exerciseService = exerciseService,
        super(ExercisesInitial()) {
    on<LoadExercises>(_onLoadExercises);
    on<AddExercise>(_onAddExercise);
  }

  Future<void> _onLoadExercises(
      LoadExercises event,
      Emitter<ExerciseState> emit,
      ) async {
    emit(ExercisesLoading());
    try {
      final exercises = await _exerciseService.fetchExercises();
      emit(ExercisesLoaded(exercises));
    } catch (e) {
      emit(ExerciseError('Помилка завантаження вправ: ${e.toString()}'));
    }
  }

  Future<void> _onAddExercise(
      AddExercise event,
      Emitter<ExerciseState> emit,
      ) async {
    try {
      await _exerciseService.createExercise(event.exercise);

      final exercises = await _exerciseService.fetchExercises();
      emit(ExercisesLoaded(exercises));
    } catch (e) {
      emit(ExerciseError('Помилка додавання вправи: ${e.toString()}'));
    }
  }
}