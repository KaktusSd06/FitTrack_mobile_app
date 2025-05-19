class GymFeedbackModel {
  final String id;
  final int rating;
  final String? title;
  final String? review;
  final DateTime date;
  final String gymId;
  final String userId;
  final String userFirstName;
  final String userLastName;
  final String userEmail;
  final String? userPictureUrl;

  GymFeedbackModel({
    required this.id,
    required this.rating,
    this.title,
    this.review,
    required this.date,
    required this.gymId,
    required this.userId,
    required this.userFirstName,
    required this.userLastName,
    required this.userEmail,
    this.userPictureUrl,
  });

  factory GymFeedbackModel.fromJson(Map<String, dynamic> json) {
    return GymFeedbackModel(
      id: json["id"],
      rating: json["rating"],
      title: json["title"],
      review: json["review"],
      date: DateTime.parse(json["date"]),
      gymId: json["gymId"],
      userId: json["userId"],
      userFirstName: json["user"]["firstName"],
      userLastName: json["user"]["lastName"],
      userEmail: json["user"]["login"],
      userPictureUrl: json["user"]["pictureUrl"],
    );
  }
}
