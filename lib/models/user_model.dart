import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String role; // 'umkm' | 'kreator'
  final String phone;
  final String city;
  final String bio;
  final String? profileImage;
  final String? businessName; // UMKM only
  final List<String> skills; // Kreator only: ['Logo','Packaging','Fotografi','Sosial Media']
  final int priceStart; // Kreator only: starting price in Rupiah
  final double rating;
  final int jobCount;

  const UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.city,
    this.bio = '',
    this.profileImage,
    this.businessName,
    this.skills = const [],
    this.priceStart = 0,
    this.rating = 0.0,
    this.jobCount = 0,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return UserModel(
      id: id ?? map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      role: map['role'] as String? ?? 'umkm',
      phone: map['phone'] as String? ?? '',
      city: map['city'] as String? ?? '',
      bio: map['bio'] as String? ?? '',
      profileImage: map['profileImage'] as String?,
      businessName: map['businessName'] as String?,
      skills: List<String>.from(map['skills'] ?? []),
      priceStart: (map['priceStart'] as num?)?.toInt() ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      jobCount: (map['jobCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'phone': phone,
      'city': city,
      'bio': bio,
      'profileImage': profileImage,
      'businessName': businessName,
      'skills': skills,
      'priceStart': priceStart,
      'rating': rating,
      'jobCount': jobCount,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? role,
    String? phone,
    String? city,
    String? bio,
    String? profileImage,
    String? businessName,
    List<String>? skills,
    int? priceStart,
    double? rating,
    int? jobCount,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
      businessName: businessName ?? this.businessName,
      skills: skills ?? this.skills,
      priceStart: priceStart ?? this.priceStart,
      rating: rating ?? this.rating,
      jobCount: jobCount ?? this.jobCount,
    );
  }

  @override
  String toString() => 'UserModel(id: $id, name: $name, role: $role)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UserModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
