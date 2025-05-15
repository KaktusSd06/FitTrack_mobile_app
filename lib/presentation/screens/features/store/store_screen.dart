import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fittrack/data/models/store/membership_model.dart';
import 'package:fittrack/data/models/store/product_model.dart';
import 'package:fittrack/data/models/store/service_model.dart';
import 'package:fittrack/presentation/screens/features/store/bloc/store_bloc.dart';
import 'package:fittrack/presentation/screens/features/store/bloc/store_event.dart';
import 'package:fittrack/presentation/screens/features/store/bloc/store_state.dart';

import '../../../dialogs/confirmation_dialog.dart';
import '../../../widgets/features/store/membership_widget.dart';
import '../../../widgets/features/store/product_widget.dart';
import '../../../widgets/features/store/service_widget.dart';

class StoreScreen extends StatefulWidget {
  final String gymId;
  final ConfirmationDialog confirmationDialog = ConfirmationDialog();

  StoreScreen({
    required this.gymId,
    Key? key,
  }) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Filtered lists
  List<ProductModel> _filteredProducts = [];
  List<MembershipModel> _filteredMemberships = [];
  List<ServiceModel> _filteredServices = [];

  // Original lists
  List<ProductModel> _products = [];
  List<MembershipModel> _memberships = [];
  List<ServiceModel> _services = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase().trim();

    setState(() {
      if (query.isEmpty) {
        _filteredProducts = List.from(_products);
        _filteredMemberships = List.from(_memberships);
        _filteredServices = List.from(_services);
      } else {
        _filteredProducts = _products
            .where((product) => product.name.toLowerCase().contains(query))
            .toList();

        _filteredMemberships = _memberships
            .where((membership) => membership.name.toLowerCase().contains(query))
            .toList();

        _filteredServices = _services
            .where((service) => service.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _updateLists({
    List<ProductModel>? products,
    List<MembershipModel>? memberships,
    List<ServiceModel>? services
  }) {
    setState(() {
      if (products != null) _products = products;
      if (memberships != null) _memberships = memberships;
      if (services != null) _services = services;
      _filterItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoreBloc()..add(GetStoreElementByGymId(gymId: widget.gymId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Магазин',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          centerTitle: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: BlocConsumer<StoreBloc, StoreState>(
          listener: (context, state) {
            if (state is StoreLoaded) {
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
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildSearchField(context),
                ),

                // Tab bar
                TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Theme.of(context).hintColor,
                  indicatorColor: Theme.of(context).primaryColor,
                  tabs: const [
                    Tab(text: 'ТОВАРИ'),
                    Tab(text: 'АБОНЕМЕНТИ'),
                    Tab(text: 'ПОСЛУГИ'),
                  ],
                ),

                // Tab bar view
                Expanded(
                  child: state is StoreLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state is StoreError
                      ? Center(child: Text('Помилка: ${state.message}'))
                      : TabBarView(
                    controller: _tabController,
                    children: [
                      // Products tab
                      _buildProductsTab(),

                      // Memberships tab
                      _buildMembershipsTab(),

                      // Services tab
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

  Widget _buildSearchField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: _searchController,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: 'Пошук',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: _filterItems,
          ),
        ),
      ),
    );
  }

  Widget _buildProductsTab() {
    if (_filteredProducts.isEmpty) {
      return Center(
        child: Text(
          _searchController.text.isNotEmpty
              ? 'За запитом "${_searchController.text}" нічого не знайдено'
              : 'Товари відсутні',
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        return ProductWidget(
          product: _filteredProducts[index],
          onBuyPressed: () {
            _showBuyProductDialog(context, _filteredProducts[index]);
          },
        );
      },
    );
  }

  Widget _buildMembershipsTab() {
    if (_filteredMemberships.isEmpty) {
      return Center(
        child: Text(
          _searchController.text.isNotEmpty
              ? 'За запитом "${_searchController.text}" нічого не знайдено'
              : 'Абонементи відсутні',
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _filteredMemberships.length,
      itemBuilder: (context, index) {
        return MembershipWidget(
          membership: _filteredMemberships[index],
          onBuyPressed: () {
            _showBuyMembershipDialog(context, _filteredMemberships[index]);
          },
        );
      },
    );
  }

  Widget _buildServicesTab() {
    if (_filteredServices.isEmpty) {
      return Center(
        child: Text(
          _searchController.text.isNotEmpty
              ? 'За запитом "${_searchController.text}" нічого не знайдено'
              : 'Послуги відсутні',
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _filteredServices.length,
      itemBuilder: (context, index) {
        return ServiceWidget(
          service: _filteredServices[index],
          onBookPressed: () {
            _showBookServiceDialog(context, _filteredServices[index]);
          },
        );
      },
    );
  }

  Future<void> _showBuyProductDialog(BuildContext context, ProductModel product) async {
    final bool confirmed = await widget.confirmationDialog.showConfirmationDialog(
        context,
        'Підтвердження',
        'Ви бажаєте придбати ${product.name}?'
    );

    // if (confirmed) {
    //   if (context.mounted) {
    //     final userUpdateBloc = context.read<UserUpdateBloc>();
    //     userUpdateBloc.add(UpdateUserTrainerEvent(trainer.id));
    //   }
    // }
  }

  Future<void> _showBuyMembershipDialog(BuildContext context,  MembershipModel membership) async {
    final bool confirmed = await widget.confirmationDialog.showConfirmationDialog(
        context,
        'Підтвердження',
        'Ви бажаєте придбати абонемент "${membership.name}"?'
    );

    // if (confirmed) {
    //   if (context.mounted) {
    //     final userUpdateBloc = context.read<UserUpdateBloc>();
    //     userUpdateBloc.add(UpdateUserTrainerEvent(trainer.id));
    //   }
    // }
  }

  Future<void> _showBookServiceDialog(BuildContext context, ServiceModel service) async {
    final bool confirmed = await widget.confirmationDialog.showConfirmationDialog(
        context,
        'Підтвердження',
        'Ви бажаєте записатись на "${service.name}"?'
    );

    // if (confirmed) {
    //   if (context.mounted) {
    //     final userUpdateBloc = context.read<UserUpdateBloc>();
    //     userUpdateBloc.add(UpdateUserTrainerEvent(trainer.id));
    //   }
    // }
  }
}