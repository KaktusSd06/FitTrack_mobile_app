import 'package:equatable/equatable.dart';
import 'package:fittrack/data/models/gym_model.dart';
import 'package:fittrack/data/models/trainer_model.dart';

abstract class ClubState extends Equatable {
  const ClubState();

  @override
  List<Object?> get props => [];
}

class ClubInitial extends ClubState {}

class ClubLoading extends ClubState {}

class ClubLoaded extends ClubState {
  final String membershipTitle, membershipDate;
  final GymModel? gym;
  final TrainerModel? trainer;

  const ClubLoaded({
    this.gym,
    required this.membershipTitle,
    required this.membershipDate,
    required this.trainer,
  });

  @override
  List<Object?> get props => [gym, membershipTitle, membershipDate, trainer];
}

class ClubError extends ClubState {
  final String message;

  const ClubError({required this.message});

  @override
  List<Object?> get props => [message];
}