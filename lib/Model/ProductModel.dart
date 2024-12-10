class Product {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
  });

  // Factory constructor to parse JSON data
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      imageUrl: json['imageUrl'],
    );
  }

  // Converts the object back to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}
