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