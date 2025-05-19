import 'package:equatable/equatable.dart';
import 'package:fittrack/data/models/gym_model.dart';
import 'package:fittrack/data/models/store/membership_model.dart';
import 'package:fittrack/data/models/store/product_model.dart';
import 'package:fittrack/data/models/store/purchases_model.dart';
import 'package:fittrack/data/models/store/user_membership_model.dart';

import '../../../../../data/models/store/service_model.dart';

abstract class PurchasesHistoryState extends Equatable {
  const PurchasesHistoryState();

  @override
  List<Object?> get props => [];
}

class PurchasesHistoryInitial extends PurchasesHistoryState {}

class PurchasesHistoryLoading extends PurchasesHistoryState {}

class PurchasesHistoryLoaded extends PurchasesHistoryState {
  final List<UserMembershipModel> memberships;
  final List<PurchaseModel> products;
  final List<PurchaseModel> services;

  const PurchasesHistoryLoaded({
    required this.memberships,
    required this.products,
    required this.services,
  });

  @override
  List<Object?> get props => [memberships, products, services];
}

class PurchasesHistoryError extends PurchasesHistoryState {
  final String message;

  const PurchasesHistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}