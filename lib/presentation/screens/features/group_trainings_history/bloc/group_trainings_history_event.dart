import 'package:equatable/equatable.dart';

abstract class GroupTrainingsHistoryEvent extends Equatable {
  const GroupTrainingsHistoryEvent();

  @override
  List<Object?> get props => [];
}

class GetGroupTrainingsByUser extends GroupTrainingsHistoryEvent {
  const GetGroupTrainingsByUser();

  @override
  List<Object?> get props => [];
}