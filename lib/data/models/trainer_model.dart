class TrainerModel{

  final String id, firstName, lastName, profileImageUrl;


  TrainerModel({required this.id, required this.firstName, required this.lastName, required this.profileImageUrl});


  factory TrainerModel.fromJson(Map<String, dynamic> json) {
    return TrainerModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profileImageUrl: json['profileImageUrl'],
    );
  }
}