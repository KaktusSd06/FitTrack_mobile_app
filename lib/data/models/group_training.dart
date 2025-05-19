class GroupTraining{
  final String id, description, trainerSurname, trainerName, contactPhone, gymId;
  final DateTime dateTime;
  final int durationInMinutes, registrationsRemaining;

  GroupTraining({required this.id,
    required this.description,
    required this.gymId,
    required this.trainerSurname,
    required this.trainerName,
    required this.durationInMinutes,
    required this.contactPhone,
    required this.dateTime,
    required this.registrationsRemaining});

  factory GroupTraining.fromJson(Map<String, dynamic> json) {
    return GroupTraining(
      id: json['id'],
      gymId: json['gymId'],
      trainerName: json['trainer']['firstName'],
      trainerSurname: json['trainer']['lastName'],
      dateTime: DateTime.parse(json['date']),
      description: json['description'],
      durationInMinutes: json['durationInMinutes'],
      contactPhone: json['contactPhone'],
      registrationsRemaining: json['registrationsRemaining'],

    );
  }
}