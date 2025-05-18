import 'package:fittrack/data/models/store/purchases_model.dart';
import 'package:fittrack/data/models/store/user_membership_model.dart';
import 'package:fittrack/data/services/gym_service.dart';
import 'package:fittrack/presentation/screens/features/purchases_history/bloc/purchases_history_event.dart';
import 'package:fittrack/presentation/screens/features/purchases_history/bloc/purchases_history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/services/purchases_service.dart';

class PurchasesHistoryBloc extends Bloc<PurchasesHistoryEvent, PurchasesHistoryState> {
  final PurchaseMembershipService _purchaseService;
  final GymService _gymService;

  PurchasesHistoryBloc({required PurchaseMembershipService service, required GymService gymService}) :
        _purchaseService = service,
        _gymService = gymService,
        super(PurchasesHistoryInitial()) {
    on<GetPurchasesHistory>(_onGetPurchasesHistory);
  }

  Future<void> _onGetPurchasesHistory(
      GetPurchasesHistory event,
      Emitter<PurchasesHistoryState> emit,
      ) async {
    emit(PurchasesHistoryLoading());
    try {

      final List<UserMembershipModel> memberships = await _purchaseService.getUserMembershipHistoryByUserId();

      final userMemberships = await Future.wait(
          memberships.map((membership) async {
            final gym = await _gymService.getGymById(membership.membership!.gymId);
            return membership.copyWith(gymTitle: gym.name);
          })
      );

      final List<PurchaseModel> allPurchases = await _purchaseService.getPurchaseHistoryByUserId();

      final productsList = allPurchases.where((purchase) => purchase.productType == "Good").toList();

      final servicesList = allPurchases.where((purchase) => purchase.productType == "Service").toList();


      emit(PurchasesHistoryLoaded(
          memberships: userMemberships, 
          products: productsList, 
          services: servicesList
      ));
    }
    catch(e){
      emit(PurchasesHistoryError(message: e.toString()));
    }
  }
}
