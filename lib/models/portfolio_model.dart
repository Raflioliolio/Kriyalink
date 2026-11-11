class PortfolioItem {
  final String id;
  final String kreatorId;
  final String title;
  final String? description;
  final String imageUrl;
  final String category;

  const PortfolioItem({
    required this.id,
    required this.kreatorId,
    required this.title,
    this.description,
    required this.imageUrl,
    required this.category,
  });

  factory PortfolioItem.fromMap(Map<String, dynamic> map, {String? id}) {
    return PortfolioItem(
      id: id ?? map['id'] as String? ?? '',
      kreatorId: map['kreatorId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String?,
      imageUrl: map['imageUrl'] as String? ?? '',
      category: map['category'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kreatorId': kreatorId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  PortfolioItem copyWith({
    String? id,
    String? kreatorId,
    String? title,
    String? description,
    String? imageUrl,
    String? category,
  }) {
    return PortfolioItem(
      id: id ?? this.id,
      kreatorId: kreatorId ?? this.kreatorId,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
    );
  }

  @override
  String toString() => 'PortfolioItem(id: $id, title: $title)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PortfolioItem && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
