import 'package:equatable/equatable.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object?> get props => [];
}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupLoaded extends GroupState {
  const GroupLoaded();

  @override
  List<Object?> get props => [];
}

class GroupError extends GroupState {
  final String message;

  const GroupError({required this.message});

  @override
  List<Object?> get props => [message];
}