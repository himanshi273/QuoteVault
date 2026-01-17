class Collection {
  final String id;
  final String name;
  final String color;

  Collection({
    required this.id,
    required this.name,
    required this.color,
  });

  factory Collection.fromMap(Map<String, dynamic> map) {
    return Collection(
      id: map['id'],
      name: map['name'],
      color: map['color'] ?? '#6750A4',
    );
  }
}
