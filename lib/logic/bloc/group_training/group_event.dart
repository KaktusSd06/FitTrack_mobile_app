import 'package:equatable/equatable.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object?> get props => [];
}

class AddUserToGroupTraining extends GroupEvent {
  final String trainingId;
  const AddUserToGroupTraining({required this.trainingId});

  @override
  List<Object?> get props => [];
}