import 'package:fittrack/data/models/store/purchases_model.dart';
import 'package:fittrack/data/models/store/user_membership_model.dart';
import 'package:fittrack/presentation/screens/features/purchases_history/bloc/purchases_history_bloc.dart';
import 'package:fittrack/presentation/screens/features/purchases_history/bloc/purchases_history_event.dart';
import 'package:fittrack/presentation/widgets/features/history/membership_history_widget.dart';
import 'package:fittrack/presentation/widgets/features/history/service_history_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/services/gym_service.dart';
import '../../../../data/services/purchases_service.dart';
import '../../../widgets/features/history/good_history_widget.dart';
import 'bloc/purchases_history_state.dart';

class PurchasesHistoryScreen extends StatefulWidget {
  const PurchasesHistoryScreen({
    super.key,
  });

  @override
  State<PurchasesHistoryScreen> createState() => _PurchasesHistoryScreenState();
}

class _PurchasesHistoryScreenState extends State<PurchasesHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final bool _isLoading = false;

  List<PurchaseModel> _products = [];
  List<UserMembershipModel> _memberships = [];
  List<PurchaseModel> _services = [];

  void _updateLists({
    List<PurchaseModel>? products,
    List<UserMembershipModel>? memberships,
    List<PurchaseModel>? services
  }) {
    setState(() {
      if (products != null) _products = products;
      if (memberships != null) _memberships = memberships;
      if (services != null) _services = services;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PurchasesHistoryBloc(service: PurchaseMembershipService(), gymService: GymService())..add(const GetPurchasesHistory()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Історія покупок',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).hintColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          centerTitle: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: BlocConsumer<PurchasesHistoryBloc, PurchasesHistoryState>(
          listener: (context, state) {
            if (state is PurchasesHistoryLoaded) {
              _updateLists(
                products: state.products,
                memberships: state.memberships,
                services: state.services,
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Theme.of(context).hintColor,
                  indicatorColor: Theme.of(context).primaryColor,
                  tabs: const [
                    Tab(text: 'Товари'),
                    Tab(text: 'Абонименти'),
                    Tab(text: 'Послуги'),
                  ],
                ),

                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state is PurchasesHistoryLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state is PurchasesHistoryError
                      ? Center(child: Text('Помилка: ${state.message}'))
                      : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildProductsTab(),

                      _buildMembershipsTab(),

                      _buildServicesTab(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        return GoodHistoryWidget(
          product: _products[index],
        );
      },
    );
  }

  Widget _buildMembershipsTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _memberships.length,
      itemBuilder: (context, index) {
        return MembershipHistoryWidget(
          membership: _memberships[index],
        );
      },
    );
  }

  Widget _buildServicesTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _services.length,
      itemBuilder: (context, index) {
        return ServiceHistoryWidget(
          service: _services[index],
        );
      },
    );
  }
}