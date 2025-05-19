import 'membership_model.dart';

class UserMembershipModel {
  final String id;
  final DateTime purchaseDate;
  final DateTime startDate;
  final DateTime? expirationDate;
  final int? remainingSessions;
  final String status;
  final String userId;
  final String membershipId;
  final MembershipModel? membership;
  final String? gymTitle;

  UserMembershipModel({
    required this.id,
    required this.purchaseDate,
    required this.startDate,
    this.expirationDate,
    this.remainingSessions,
    required this.status,
    required this.userId,
    required this.membershipId,
    this.membership,
    this.gymTitle
  });

  factory UserMembershipModel.fromJson(Map<String, dynamic> json) {
    return UserMembershipModel(
      id: json['id'] ?? '',
      purchaseDate: json['purchaseDate'] != null
          ? DateTime.parse(json['purchaseDate'])
          : DateTime.now(),
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      expirationDate: json['expirationDate'] != null
          ? DateTime.parse(json['expirationDate'])
          : null,
      remainingSessions: json['remainingSessions'],
      status: json['status'] ?? '',
      userId: json['userId'] ?? '',
      membershipId: json['membershipId'] ?? '',
      membership: json['membership'] != null
          ? MembershipModel.fromJson(json['membership'])
          : null,
      gymTitle: json['gymTitle'],
    );
  }

  // Add a copyWith method to create a new instance with updated properties
  UserMembershipModel copyWith({
    String? id,
    DateTime? purchaseDate,
    DateTime? startDate,
    DateTime? expirationDate,
    int? remainingSessions,
    String? status,
    String? userId,
    String? membershipId,
    MembershipModel? membership,
    String? gymTitle,
  }) {
    return UserMembershipModel(
      id: id ?? this.id,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      startDate: startDate ?? this.startDate,
      expirationDate: expirationDate ?? this.expirationDate,
      remainingSessions: remainingSessions ?? this.remainingSessions,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      membershipId: membershipId ?? this.membershipId,
      membership: membership ?? this.membership,
      gymTitle: gymTitle ?? this.gymTitle,
    );
  }

  bool get isActive => status.toLowerCase() == 'active';

  bool get isExpired {
    if (expirationDate == null) return false;
    return DateTime.now().isAfter(expirationDate!);
  }

  bool get hasRemainingSessions {
    if (remainingSessions == null) return true;
    return remainingSessions! > 0;
  }
}