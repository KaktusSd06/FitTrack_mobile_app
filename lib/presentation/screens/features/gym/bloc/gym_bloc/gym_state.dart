import 'package:equatable/equatable.dart';
import 'package:fittrack/data/models/gym_model.dart';

abstract class GymState extends Equatable {
  const GymState();

  @override
  List<Object?> get props => [];
}

class GymInitial extends GymState {}

class GymLoading extends GymState {}

class GymLoaded extends GymState {
  final List<GymModel> gyms;

  const GymLoaded({
    required this.gyms,
  });

  @override
  List<Object?> get props => [gyms];
}

class GymError extends GymState {
  final String message;

  const GymError({required this.message});

  @override
  List<Object?> get props => [message];
}