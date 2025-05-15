class ServiceModel{
  final String id, name, description;
  final int price;

  ServiceModel({required this.id, required this.name, required this.description, required this.price});


  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
    );
  }
}