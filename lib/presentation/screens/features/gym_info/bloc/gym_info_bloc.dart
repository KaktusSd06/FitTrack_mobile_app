import 'package:fittrack/data/models/gym_feedback_model.dart';
import 'package:fittrack/data/services/gym_feedback_service.dart';
import 'package:fittrack/data/services/gym_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'gym_info_event.dart';
import 'gym_info_state.dart';

class GymInfoBloc extends Bloc<GymInfoEvent, GymInfoState> {
  final GymService _gymService;
  final GymFeedbackService _gymFeedbackService;

  GymInfoBloc({required GymService gymService, required GymFeedbackService gymFeedbackService}) :
        _gymService = gymService,
        _gymFeedbackService = gymFeedbackService,
        super(GymInfoInitial()) {
    on<GetGymById>(_onGetAllGyms);
    on<DeleteFeedback>(_onDeleteFeedback);
  }

  Future<void> _onGetAllGyms(
      GetGymById event,
      Emitter<GymInfoState> emit,
      ) async {
    emit(GymInfoLoading());
    try {
      var gym = await _gymService.getGymById(event.gymId);
      var gymFeedback = await _gymFeedbackService.getFeedbacksByGymId(event.gymId);

      emit(GymInfoLoaded(
        gym: gym,
        gymFeedbacks: gymFeedback,
      ));
    }
    catch(e){
      emit(GymInfoError(message: e.toString()));
    }
  }

  Future<void> _onDeleteFeedback(
      DeleteFeedback event,
      Emitter<GymInfoState> emit,
      ) async {
    try {
      final currentState = state;
      if (currentState is GymInfoLoaded) {
        await _gymFeedbackService.deleteFeedback(event.feedbackId);

        final updatedFeedbacks = currentState.gymFeedbacks
            .where((feedback) => feedback.id != event.feedbackId)
            .toList();

        emit(GymInfoLoaded(
          gym: currentState.gym,
          gymFeedbacks: updatedFeedbacks,
        ));
      }
    } catch (e) {
      emit(GymInfoError(message: 'Помилка видалення відгуку: ${e.toString()}'));
    }
  }
}