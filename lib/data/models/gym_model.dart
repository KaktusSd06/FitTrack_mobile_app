class GymModel {
  final String id;
  final String name;
  final double  rating;
  final String ownerId;
  final String? mainImagePreSignedUrl;
  final Address address;

  GymModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.ownerId,
    this.mainImagePreSignedUrl,
    required this.address,
  });

  factory GymModel.fromJson(Map<String, dynamic> json) {
    return GymModel(
      id: json['id'],
      name: json['name'],
      rating: json['rating'],
      ownerId: json['ownerId'],
      mainImagePreSignedUrl: json['mainImagePreSignedUrl'],
      address: Address.fromJson(json['address']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rating': rating,
      'ownerId': ownerId,
      'mainImagePreSignedUrl': mainImagePreSignedUrl,
      'address': address.toJson(),
    };
  }
}

class GymImage {
  final String? name;
  final String? preSignedUrl;

  GymImage({this.name, this.preSignedUrl});

  factory GymImage.fromJson(Map<String, dynamic> json) {
    return GymImage(
      name: json['name'],
      preSignedUrl: json['preSignedUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'preSignedUrl': preSignedUrl,
    };
  }
}

class Address {
  final String country;
  final String city;
  final String street;
  final String building;
  final String zipCode;

  Address({
    required this.country,
    required this.city,
    required this.street,
    required this.building,
    required this.zipCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      country: json['country'],
      city: json['city'],
      street: json['street'],
      building: json['building'],
      zipCode: json['zipCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'city': city,
      'street': street,
      'building': building,
      'zipCode': zipCode,
    };
  }
}
