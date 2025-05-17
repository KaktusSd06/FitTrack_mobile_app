import 'package:equatable/equatable.dart';

abstract class PurchasesHistoryEvent extends Equatable {
  const PurchasesHistoryEvent();

  @override
  List<Object?> get props => [];
}

class GetPurchasesHistory extends PurchasesHistoryEvent {
  const GetPurchasesHistory();

  @override
  List<Object?> get props => [];
}