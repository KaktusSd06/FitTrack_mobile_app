import '../store/product_model.dart';

class PurchaseModel {
  final String id;
  final double price;
  final DateTime purchaseDate;
  final String productId;
  final String? productType;
  final ProductModel? product;
  final String userId;
  final String gymId;

  PurchaseModel({
    required this.id,
    required this.price,
    required this.purchaseDate,
    required this.productId,
    this.product,
    this.productType,
    required this.userId,
    required this.gymId,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      id: json['id'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      purchaseDate: json['purchaseDate'] != null
          ? DateTime.parse(json['purchaseDate'])
          : DateTime.now(),
      productId: json['productId'] ?? '',
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
      productType: json['product']['productType'] ?? '',
      userId: json['userId'] ?? '',
      gymId: json['gymId'] ?? '',
    );
  }
}