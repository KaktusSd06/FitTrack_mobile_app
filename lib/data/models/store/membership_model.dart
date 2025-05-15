class MembershipModel{
  final String id, name, type, gymId;
  final int? allowedSessions, durationMonth;
  final int price;

  MembershipModel({required this.id, required this.name, required this.type, required this.gymId,
    required this.allowedSessions, required this.durationMonth, required this.price});


  factory MembershipModel.fromJson(Map<String, dynamic> json) {
    return MembershipModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      gymId: json['gymId'],
      allowedSessions: json['allowedSessions'],
      durationMonth: json['durationMonth'],
      price: json['price'],
    );
  }
}