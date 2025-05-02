import 'package:fittrack/data/models/set_model.dart';

class IndividualTrainingModel {
  final String id;
  final String userId;
  final List<SetModel> sets;
  final DateTime date;

  IndividualTrainingModel({
    required this.id,
    required this.userId,
    required this.sets,
    required this.date,
  });

  factory IndividualTrainingModel.fromJson(Map<String, dynamic> json) {
    return IndividualTrainingModel(
      id: json['id'],
        userId: json['userId'] ?? '',
      sets: (json['sets'] as List<dynamic>?)
          ?.map((item) => SetModel.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      date: DateTime.parse(json['date']),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'sets': sets.map((set) => set.toJson()).toList(),
      'date': date.toUtc().toIso8601String(),
    };
  }
}
