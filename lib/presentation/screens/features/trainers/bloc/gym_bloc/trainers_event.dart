import 'package:equatable/equatable.dart';

abstract class TrainersEvent extends Equatable {
  const TrainersEvent();

  @override
  List<Object?> get props => [];
}

class GetAllTrainersByGymId extends TrainersEvent {
  final String gymId;
  const GetAllTrainersByGymId({required this.gymId});

  @override
  List<Object?> get props => [gymId];
}