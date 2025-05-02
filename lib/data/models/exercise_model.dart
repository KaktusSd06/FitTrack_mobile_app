class ExerciseModel {
  final String id;
  final String name;
  final String? description;

  ExerciseModel({
    required this.id,
    required this.name,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
  };

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}