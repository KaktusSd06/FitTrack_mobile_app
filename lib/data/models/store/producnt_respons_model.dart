class ProductApiModel{
  final String id, name, description, productType;
  final String? imageUrl;
  final double price;

  ProductApiModel({required this.id, required this.name, required this.productType, required this.description,  this.imageUrl, required this.price});


  factory ProductApiModel.fromJson(Map<String, dynamic> json) {
    return ProductApiModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      productType: json['productType'],
      price: json['price'],
    );
  }
}