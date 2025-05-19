import 'package:equatable/equatable.dart';

abstract class GymEvent extends Equatable {
  const GymEvent();

  @override
  List<Object?> get props => [];
}

class GetAllGyms extends GymEvent {
  const GetAllGyms();

  @override
  List<Object?> get props => [];
}