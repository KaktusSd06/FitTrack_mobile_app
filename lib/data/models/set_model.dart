import 'exercise_model.dart';

class SetModel {
  final String? id;
  final double weight;
  final int reps;
  final String exerciseId;
  final ExerciseModel? exercise;
  String? individualTrainingId;

  SetModel({
    this.id,
    required this.weight,
    required this.reps,
    required this.exerciseId,
    this.exercise,
    this.individualTrainingId,
  });

  factory SetModel.fromJson(Map<String, dynamic> json) {
    return SetModel(
      id: json['id'],
      weight: (json['weight'] ?? 0).toDouble(),
      reps: json['reps'],
      exerciseId: json['exerciseId'] ?? json['id'],
      exercise: json['exercise'] != null ? ExerciseModel.fromJson(json['exercise']) : null,
        individualTrainingId: json["individualTrainingId"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weight': weight,
      'reps': reps,
      'exerciseId': exerciseId,
      'exercise': exercise?.toJson(),
      'individualTrainingId': individualTrainingId,
    };
  }
}
