import 'package:fittrack/data/services/gym_service.dart';
import 'package:fittrack/presentation/screens/features/store/bloc/store_event.dart';
import 'package:fittrack/presentation/screens/features/store/bloc/store_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/models/store/membership_model.dart';
import '../../../../../data/models/store/product_model.dart';
import '../../../../../data/models/store/service_model.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {

  StoreBloc() : super(StoreInitial()) {
    on<GetStoreElementByGymId>(_onGetStoreElementsByGymId);
  }

  Future<void> _onGetStoreElementsByGymId(
      GetStoreElementByGymId event,
      Emitter<StoreState> emit,
      ) async {
    emit(StoreLoading());
    try {

      final List<ProductModel> productsList = [
        ProductModel(
          id: 'p1',
          name: 'Протеїновий батончик',
          description: 'Смачний протеїновий батончик з високим вмістом білка',
          imageUrl: 'https://example.com/protein_bar.jpg',
          price: 75,
        ),
        ProductModel(
          id: 'p2',
          name: 'Спортивна пляшка для води',
          description: 'Зручна пляшка для води ємністю 750 мл',
          imageUrl: 'https://example.com/water_bottle.jpg',
          price: 250,
        ),
        ProductModel(
          id: 'p3',
          name: 'Спортивні рукавички',
          description: 'Рукавички для тренувань з натуральної шкіри',
          imageUrl: 'https://example.com/gloves.jpg',
          price: 450,
        ),
      ];

      final List<MembershipModel> membershipsList = [
        MembershipModel(
          id: 'm1',
          name: 'Базовий',
          type: 'SessionLimited',
          gymId: 'gym123',
          allowedSessions: 12,
          durationMonth: null,
          price: 600,
        ),
        MembershipModel(
          id: 'm2',
          name: 'Стандарт',
          type: 'TimeLimited',
          gymId: 'gym123',
          allowedSessions: null,
          durationMonth: 3,
          price: 1500,
        ),
        MembershipModel(
          id: 'm3',
          name: 'Преміум',
          type: 'Combined',
          gymId: 'gym123',
          allowedSessions: 100,
          durationMonth: 12,
          price: 5000,
        ),
      ];

      final List<ServiceModel> servicesList = [
        ServiceModel(
          id: 's1',
          name: 'Персональне тренування',
          description: 'Індивідуальне тренування з професійним тренером',
          price: 500,
        ),
        ServiceModel(
          id: 's2',
          name: 'Масаж',
          description: 'Спортивний масаж для відновлення м\'язів',
          price: 700,
        ),
        ServiceModel(
          id: 's3',
          name: 'Нутриціологічна консультація',
          description: 'Розробка індивідуального плану харчування',
          price: 800,
        ),
      ];

      emit(StoreLoaded(memberships: membershipsList, products: productsList, services: servicesList));
    }
    catch(e){
      emit(StoreError(message: e.toString()));
    }
  }
}
