import 'package:fittrack/data/services/membership_service.dart';
import 'package:fittrack/data/services/product_service.dart';
import 'package:fittrack/presentation/constants/payment_configurations.dart';
import 'package:fittrack/presentation/dialogs/error_dialog.dart';
import 'package:fittrack/presentation/dialogs/success_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fittrack/data/models/store/membership_model.dart';
import 'package:fittrack/data/models/store/product_model.dart';
import 'package:fittrack/data/models/store/service_model.dart';
import 'package:fittrack/presentation/screens/features/store/bloc/store_bloc.dart';
import 'package:fittrack/presentation/screens/features/store/bloc/store_event.dart';
import 'package:fittrack/presentation/screens/features/store/bloc/store_state.dart';
import 'package:pay/pay.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../data/services/purchases_service.dart';
import '../../../dialogs/confirmation_dialog.dart';
import '../../../widgets/features/store/membership_widget.dart';
import '../../../widgets/features/store/product_widget.dart';
import '../../../widgets/features/store/service_widget.dart';

class StoreScreen extends StatefulWidget {
  final String gymId;
  final ConfirmationDialog confirmationDialog = ConfirmationDialog();
  final ErrorDialog errorDialog = ErrorDialog();
  final SuccessDialog successDialog = SuccessDialog();
  StoreScreen({
    required this.gymId,
    super.key,
  });

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  late PurchaseMembershipService _purchaseMembershipService;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? _userId;
  bool _isLoading = false;

  List<ProductModel> _filteredProducts = [];
  List<MembershipModel> _filteredMemberships = [];
  List<ServiceModel> _filteredServices = [];

  List<ProductModel> _products = [];
  List<MembershipModel> _memberships = [];
  List<ServiceModel> _services = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(_filterItems);
    _purchaseMembershipService = PurchaseMembershipService();
    _getUserId();
  }

  Future<void> _getUserId() async {
    _userId = await _secureStorage.read(key: 'userId');
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
      create: (context) => StoreBloc(membershipService: MembershipService(), productService: ProductService())..add(GetStoreElementByGymId(gymId: widget.gymId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Магазин',
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildSearchField(context),
                ),

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
                      : state is StoreLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state is StoreError
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

    if (confirmed && context.mounted) {
      _showPaymentSheet(
        context,
        product.name,
        product.price.toString(),
            () => _processProductPurchase(product),
      );
    }
  }

  Future<void> _showBuyMembershipDialog(BuildContext context, MembershipModel membership) async {
    final bool confirmed = await widget.confirmationDialog.showConfirmationDialog(
        context,
        'Підтвердження',
        'Ви бажаєте придбати абонемент "${membership.name}"?'
    );

    if (confirmed && context.mounted) {
      _showPaymentSheet(
        context,
        membership.name,
        membership.price.toString(),
            () => _processMembershipPurchase(membership),
      );
    }
  }

  Future<void> _showBookServiceDialog(BuildContext context, ServiceModel service) async {
    final bool confirmed = await widget.confirmationDialog.showConfirmationDialog(
        context,
        'Підтвердження',
        'Ви бажаєте записатись на "${service.name}"?'
    );

    if (confirmed && context.mounted) {
      _showPaymentSheet(
        context,
        service.name,
        service.price.toString(),
            () => _processServicePurchase(service),
      );
    }
  }

  void _showPaymentSheet(BuildContext context, String itemName, String price, Function onPaymentSuccess) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Оплата',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Товар:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(itemName),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Сума до сплати:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$price грн',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  )

                ],
              ),
            ),

            const Divider(),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GooglePayButton(
                paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
                paymentItems: [
                  PaymentItem(
                    label: itemName,
                    amount: price,
                    status: PaymentItemStatus.final_price,
                  )
                ],
                width: double.infinity,
                height: 50,
                type: GooglePayButtonType.pay,
                margin: const EdgeInsets.only(top: 15),
                onPaymentResult: (result) async {
                  Navigator.pop(context);
                  await onPaymentSuccess();
                },
                loadingIndicator: const Center(child: CircularProgressIndicator()),
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    backgroundColor: Theme.of(context).primaryColor
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _showCreditCardPaymentDialog(context, itemName, price, onPaymentSuccess);
                },
                child: Text('Ввести дані самостійно', style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentSuccessDialog(BuildContext context, String message) {
    widget.successDialog.showSuccessDialog(
        context,
        'Успішна оплата',
        message
    );
  }

  void _showErrorDialog(BuildContext context, String error) {
    widget.errorDialog.showErrorDialog(
        context,
        'Помилка',
        'Виникла помилка під час обробки замовлення'
    );
  }

  void _showErrorDialogMembership(BuildContext context) {
    widget.errorDialog.showErrorDialog(
        context,
        'Помилка',
        'У вас вже є абонимент зі статусом очікування для цього залу'
    );
  }

  void _showCreditCardPaymentDialog(
      BuildContext context,
      String itemName,
      String price,
      Function onPaymentSuccess
      ) {
    final cardNumberController = TextEditingController();
    final expiryDateController = TextEditingController();
    final cvcController = TextEditingController();

    bool areAllFieldsFilled = false;

    void checkFields() {
      final isCardNumberValid = cardNumberController.text.replaceAll(' ', '').length == 16;
      final isExpiryDateValid = expiryDateController.text.length == 5;
      final isCvcValid = cvcController.text.length == 3;

      areAllFieldsFilled = isCardNumberValid && isExpiryDateValid && isCvcValid;
    }

    showCupertinoDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return CupertinoAlertDialog(
                title: const Text('Додайте платіжні дані'),
                content: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Товар: $itemName', style: const TextStyle(fontSize: 14)),
                        Text('Сума: $price грн', style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                        const SizedBox(height: 16),
                        CupertinoTextField(
                          controller: cardNumberController,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          placeholder: '0000 0000 0000 0000',
                          placeholderStyle: const TextStyle(
                            color: CupertinoColors.systemGrey,
                            fontSize: 14,
                          ),
                          keyboardType: TextInputType.number,
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey6,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onChanged: (value) {
                            setState(() {
                              checkFields();
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: CupertinoTextField(
                                controller: expiryDateController,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                placeholder: 'MM/YY',
                                placeholderStyle: const TextStyle(
                                  color: CupertinoColors.systemGrey,
                                  fontSize: 14,
                                ),
                                keyboardType: TextInputType.number,
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey6,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    checkFields();
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CupertinoTextField(
                                controller: cvcController,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                placeholder: '000',
                                placeholderStyle: const TextStyle(
                                  color: CupertinoColors.systemGrey,
                                  fontSize: 14,
                                ),
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey6,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    checkFields();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Скасувати'),
                  ),
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: areAllFieldsFilled ? () async {
                      Navigator.pop(dialogContext);
                      await onPaymentSuccess();
                    } : null,
                    child: Text('Оплатити',
                      style: TextStyle(
                        color: areAllFieldsFilled
                            ? CupertinoColors.activeBlue
                            : CupertinoColors.systemGrey,
                      ),
                    ),
                  ),
                ],
              );
            }
        );
      },
    );
  }

  Future<void> _processProductPurchase(ProductModel product) async {
    if (_userId == null) {
      _showErrorDialog(context, 'Не вдалося отримати інформацію про користувача. Будь ласка, увійдіть знову.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final purchaseId = await _purchaseMembershipService.createPurchase(
        product.price,
        product.id,
        widget.gymId,
      );

      setState(() {
        _isLoading = false;
      });

      if (context.mounted) {
        _showPaymentSuccessDialog(
            context,
            'Дякуємо за покупку ${product.name}! Ваше замовлення успішно оформлено.'
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (context.mounted) {
        _showErrorDialog(context, e.toString());
      }
    }
  }

  Future<void> _processMembershipPurchase(MembershipModel membership) async {
    if (_userId == null) {
      _showErrorDialog(context, 'Не вдалося отримати інформацію про користувача. Будь ласка, увійдіть знову.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final membershipId = await _purchaseMembershipService.createUserMembership(
        _userId!,
        membership.id,
      );

      setState(() {
        _isLoading = false;
      });

      if (context.mounted && membershipId.isNotEmpty) {
        _showPaymentSuccessDialog(
            context,
            'Дякуємо за покупку абонементу "${membership.name}"! Ваш абонемент успішно активовано.'
        );
      }
      else{
        _showErrorDialogMembership(context);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (context.mounted) {
        _showErrorDialog(context, e.toString());
      }
    }
  }

  Future<void> _processServicePurchase(ServiceModel service) async {
    if (_userId == null) {
      _showErrorDialog(context, 'Не вдалося отримати інформацію про користувача. Будь ласка, увійдіть знову.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final purchaseId = await _purchaseMembershipService.createPurchase(
        service.price,
        service.id,
        widget.gymId,
      );

      setState(() {
        _isLoading = false;
      });

      if (context.mounted) {
        _showPaymentSuccessDialog(
            context,
            'Дякуємо за запис на "${service.name}"! Ваш запис успішно оформлено.'
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (context.mounted) {
        _showErrorDialog(context, e.toString());
      }
    }
  }
}