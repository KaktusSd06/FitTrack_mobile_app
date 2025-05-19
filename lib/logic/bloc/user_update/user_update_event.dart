import 'package:equatable/equatable.dart';

abstract class UserUpdateEvent extends Equatable {
  const UserUpdateEvent();

  @override
  List<Object?> get props => [];
}

class UpdateUserGymEvent extends UserUpdateEvent {
  final String gymId;

  const UpdateUserGymEvent(this.gymId);

  @override
  List<Object?> get props => [gymId];
}

class UpdateUserTrainerEvent extends UserUpdateEvent {
  final String trainerId;

  const UpdateUserTrainerEvent(this.trainerId);

  @override
  List<Object?> get props => [trainerId];
}

class UpdateUserDetailsEvent extends UserUpdateEvent {
  final String? gymId;
  final String? trainerId;

  const UpdateUserDetailsEvent({this.gymId, this.trainerId});

  @override
  List<Object?> get props => [gymId, trainerId];
}