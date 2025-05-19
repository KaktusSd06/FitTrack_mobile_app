import 'package:fittrack/data/services/product_service.dart';
import 'package:fittrack/presentation/screens/features/store/bloc/store_event.dart';
import 'package:fittrack/presentation/screens/features/store/bloc/store_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/models/store/membership_model.dart';
import '../../../../../data/models/store/product_model.dart';
import '../../../../../data/models/store/service_model.dart';
import '../../../../../data/services/membership_service.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final ProductService _productService;
  final MembershipService _membershipService;

  StoreBloc({required ProductService productService, required MembershipService membershipService}) :
      _productService = productService,
      _membershipService = membershipService,
        super(StoreInitial()) {
    on<GetStoreElementByGymId>(_onGetStoreElementsByGymId);
  }

  Future<void> _onGetStoreElementsByGymId(
      GetStoreElementByGymId event,
      Emitter<StoreState> emit,
      ) async {
    emit(StoreLoading());
    try {

      final List<ProductModel> productsList = await _productService.getProductsByGymId(event.gymId);

      final List<MembershipModel> membershipsList = await _membershipService.getMembershipsByGymId(event.gymId);

      final List<ServiceModel> servicesList = await _productService.getServicesByGymid(event.gymId);

      emit(StoreLoaded(memberships: membershipsList, products: productsList, services: servicesList));
    }
    catch(e){
      emit(StoreError(message: e.toString()));
    }
  }
}
