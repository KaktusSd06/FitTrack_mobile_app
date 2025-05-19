import 'package:equatable/equatable.dart';

abstract class GymInfoEvent extends Equatable {
  const GymInfoEvent();

  @override
  List<Object?> get props => [];
}

class GetGymById extends GymInfoEvent {
  final String gymId;
  const GetGymById({required this.gymId});

  @override
  List<Object?> get props => [gymId];
}

class DeleteFeedback extends GymInfoEvent {
  final String feedbackId;

  const DeleteFeedback({required this.feedbackId});

  @override
  List<Object?> get props => [feedbackId];
}