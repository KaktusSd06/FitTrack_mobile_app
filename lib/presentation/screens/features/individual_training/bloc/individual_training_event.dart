import 'package:equatable/equatable.dart';

import '../../../../../data/models/set_model.dart';

abstract class IndividualTrainingEvent extends Equatable {
  const IndividualTrainingEvent();

  @override
  List<Object?> get props => [];
}

class GetIndividualTrainingsByPeriod extends IndividualTrainingEvent {
  final DateTime fromDate;
  final DateTime toDate;

  const GetIndividualTrainingsByPeriod({
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object?> get props => [fromDate, toDate];
}

class CreateIndividualTraining extends IndividualTrainingEvent {
  final DateTime date;
  final List<SetModel>? sets;
  final String? trainerId;

  const CreateIndividualTraining({
    required this.date,
    required this.sets,
    this.trainerId,
  });

  @override
  List<Object?> get props => [date, sets, trainerId];
}