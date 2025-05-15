class MessageModel{
  final String message, trainerFirstname, trainerLastname;
  final DateTime createdAt, mealDate;

  MessageModel({required this.message,
    required this.trainerFirstname,
    required this.trainerLastname,
    required this.createdAt,
    required this.mealDate});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json['message'],
      trainerFirstname: json['trainer']['firstName'],
      trainerLastname: json['trainer']['lastName'],
      createdAt: DateTime.parse(json['createdAt']),
      mealDate: DateTime.parse(json['mealDate']),
    );
  }
}