import 'package:equatable/equatable.dart';

abstract class StoreEvent extends Equatable {
  const StoreEvent();

  @override
  List<Object?> get props => [];
}

class GetStoreElementByGymId extends StoreEvent {
  final String gymId;
  const GetStoreElementByGymId({
    required this.gymId,
});

  @override
  List<Object?> get props => [gymId];
}