import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRequest {
  final String id;
  final String umkmId;
  final String kreatorId;
  final String serviceType; // 'logo' | 'packaging' | 'foto' | 'sosmed'
  final String description;
  final String budgetRange;
  final DateTime deadline;
  final String status; // 'pending' | 'accepted' | 'done'
  final DateTime createdAt;

  const ServiceRequest({
    required this.id,
    required this.umkmId,
    required this.kreatorId,
    required this.serviceType,
    required this.description,
    required this.budgetRange,
    required this.deadline,
    this.status = 'pending',
    required this.createdAt,
  });

  factory ServiceRequest.fromMap(Map<String, dynamic> map, {String? id}) {
    return ServiceRequest(
      id: id ?? map['id'] as String? ?? '',
      umkmId: map['umkmId'] as String? ?? '',
      kreatorId: map['kreatorId'] as String? ?? '',
      serviceType: map['serviceType'] as String? ?? '',
      description: map['description'] as String? ?? '',
      budgetRange: map['budgetRange'] as String? ?? '',
      deadline: map['deadline'] is Timestamp
          ? (map['deadline'] as Timestamp).toDate()
          : DateTime.tryParse(map['deadline']?.toString() ?? '') ??
              DateTime.now(),
      status: map['status'] as String? ?? 'pending',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
              DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'umkmId': umkmId,
      'kreatorId': kreatorId,
      'serviceType': serviceType,
      'description': description,
      'budgetRange': budgetRange,
      'deadline': Timestamp.fromDate(deadline),
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  ServiceRequest copyWith({
    String? id,
    String? umkmId,
    String? kreatorId,
    String? serviceType,
    String? description,
    String? budgetRange,
    DateTime? deadline,
    String? status,
    DateTime? createdAt,
  }) {
    return ServiceRequest(
      id: id ?? this.id,
      umkmId: umkmId ?? this.umkmId,
      kreatorId: kreatorId ?? this.kreatorId,
      serviceType: serviceType ?? this.serviceType,
      description: description ?? this.description,
      budgetRange: budgetRange ?? this.budgetRange,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'ServiceRequest(id: $id, type: $serviceType, status: $status)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ServiceRequest && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
