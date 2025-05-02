import 'package:bloc/bloc.dart';
import '../../../../../data/services/individual_training_service.dart';
import 'individual_training_event.dart';
import 'individual_training_state.dart';

class IndividualTrainingBloc extends Bloc<IndividualTrainingEvent, IndividualTrainingState> {
  final IndividualTrainingService _trainingService;

  IndividualTrainingBloc({required IndividualTrainingService trainingService})
      : _trainingService = trainingService,
        super(IndividualTrainingInitial()) {
    on<GetIndividualTrainingsByPeriod>(_onGetIndividualTrainingsByPeriod);
    on<CreateIndividualTraining>(_onCreateIndividualTraining);
  }

  Future<void> _onGetIndividualTrainingsByPeriod(
      GetIndividualTrainingsByPeriod event,
      Emitter<IndividualTrainingState> emit,
      ) async {
    try {
      emit(IndividualTrainingLoading());

      final trainings = await _trainingService.getIndividualTrainingsByPeriod(
        fromDate: event.fromDate,
        toDate: event.toDate,
      );

      emit(IndividualTrainingLoaded(trainings: trainings));
    } catch (e) {
      emit(IndividualTrainingError(message: e.toString()));
    }
  }

  Future<void> _onCreateIndividualTraining(
      CreateIndividualTraining event,
      Emitter<IndividualTrainingState> emit,
      ) async {
    try {
      emit(IndividualTrainingLoading());

      await _trainingService.createIndividualTraining(
        date: event.date,
        trainerId: event.trainerId,
      );

      emit(IndividualTrainingCreated());

      final updatedTrainings = await _trainingService.getIndividualTrainingsByPeriod(
        fromDate: DateTime(event.date.year, event.date.month, 1),
        toDate: DateTime(event.date.year, event.date.month + 1, 0),
      );

      emit(IndividualTrainingLoaded(trainings: updatedTrainings));
    } catch (e) {
      emit(IndividualTrainingError(message: e.toString()));
    }
  }
}