import 'package:equatable/equatable.dart';
import 'package:fittrack/data/models/gym_model.dart';

import '../../../../../data/models/gym_feedback_model.dart';

abstract class GymInfoState extends Equatable {
  const GymInfoState();

  @override
  List<Object?> get props => [];
}

class GymInfoInitial extends GymInfoState {}

class GymInfoLoading extends GymInfoState {}

class GymInfoLoaded extends GymInfoState {
  final GymModel gym;
  final List<GymFeedbackModel> gymFeedbacks;

  const GymInfoLoaded({
    required this.gym,
    required this.gymFeedbacks,
  });

  @override
  List<Object?> get props => [gym, gymFeedbacks];
}

class GymInfoError extends GymInfoState {
  final String message;

  const GymInfoError({required this.message});

  @override
  List<Object?> get props => [message];
}