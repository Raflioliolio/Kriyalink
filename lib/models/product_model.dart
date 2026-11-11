import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String userId;
  final String name;
  final String description;
  final int price; // in Rupiah
  final String? imageUrl;
  final DateTime createdAt;

  const ProductModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.createdAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return ProductModel(
      id: id ?? map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      price: (map['price'] as num?)?.toInt() ?? 0,
      imageUrl: map['imageUrl'] as String?,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
              DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  ProductModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    int? price,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'ProductModel(id: $id, name: $name, price: $price)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ProductModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
