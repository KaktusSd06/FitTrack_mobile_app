import 'package:equatable/equatable.dart';

abstract class GroupTrainingEvent extends Equatable {
  const GroupTrainingEvent();

  @override
  List<Object?> get props => [];
}

class GetGroupTrainingsByDate extends GroupTrainingEvent {
  final DateTime date;
  final String gymId;
  const GetGroupTrainingsByDate({required this.date, required this.gymId});

  @override
  List<Object?> get props => [];
}