import 'package:equatable/equatable.dart';

abstract class ClubEvent extends Equatable {
  const ClubEvent();

  @override
  List<Object?> get props => [];
}

class GetClubInfo extends ClubEvent {
  const GetClubInfo();

  @override
  List<Object?> get props => [];
}