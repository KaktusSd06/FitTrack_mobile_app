import 'package:equatable/equatable.dart';
import 'package:fittrack/data/models/gym_model.dart';
import 'package:fittrack/data/models/store/membership_model.dart';
import 'package:fittrack/data/models/store/product_model.dart';

import '../../../../../data/models/store/service_model.dart';

abstract class StoreState extends Equatable {
  const StoreState();

  @override
  List<Object?> get props => [];
}

class StoreInitial extends StoreState {}

class StoreLoading extends StoreState {}

class StoreLoaded extends StoreState {
  final List<MembershipModel> memberships;
  final List<ProductModel> products;
  final List<ServiceModel> services;

  const StoreLoaded({
    required this.memberships,
    required this.products,
    required this.services,
  });

  @override
  List<Object?> get props => [memberships, products, services];
}

class StoreError extends StoreState {
  final String message;

  const StoreError({required this.message});

  @override
  List<Object?> get props => [message];
}