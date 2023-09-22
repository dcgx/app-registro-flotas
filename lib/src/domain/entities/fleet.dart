class Fleet {
  final String? id;
  final String? name;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  Fleet({
    this.id,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Fleet.fromMap(Map<String, dynamic> data) {
    return Fleet(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }
}
