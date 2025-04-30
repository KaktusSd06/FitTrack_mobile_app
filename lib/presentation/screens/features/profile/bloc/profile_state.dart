import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String? displayName;
  final String? photoUrl;

  const ProfileLoaded({this.displayName, this.photoUrl});

  @override
  List<Object?> get props => [displayName, photoUrl];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class AccountDeleted extends ProfileState {}

class AccountDeletionError extends ProfileState {
  final String message;
  const AccountDeletionError(this.message);

  @override
  List<Object?> get props => [message];
}

