class ProductModel{
  final String id, name, description, imageUrl;
  final double price;

  ProductModel({required this.id, required this.name, required this.description, required this.imageUrl, required this.price});


  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      price: json['price'],
    );
  }
}