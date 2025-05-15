import 'package:equatable/equatable.dart';

abstract class UserUpdateState extends Equatable {
  const UserUpdateState();

  @override
  List<Object?> get props => [];
}

class UserUpdateInitial extends UserUpdateState {}

class UserUpdateLoading extends UserUpdateState {}

class UserUpdateSuccess extends UserUpdateState {}

class UserUpdateFailure extends UserUpdateState {
  final String errorMessage;

  const UserUpdateFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}