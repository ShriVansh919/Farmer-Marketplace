class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final String description;
  final double rating;
  final int stock;
  final String image;
  final String imageUrl;
  final String farmerName;
  final String location;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.description,
    required this.rating,
    required this.stock,
    required this.image,
    required this.imageUrl,
    required this.farmerName,
    required this.location,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'].toString(),
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
        category: (json['category'] ?? '') as String,
        description: (json['description'] ?? '') as String,
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        stock: (json['stock'] as num?)?.toInt() ?? 0,
        image: (json['image'] ?? '🥗') as String,
        imageUrl: (json['imageUrl'] ?? '') as String,
        farmerName: (json['farmerName'] ?? '') as String,
        location: (json['location'] ?? '') as String,
      );
}