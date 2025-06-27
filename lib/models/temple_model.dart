class TempleModel {
  final String id;
  final String name;
  final String samaj;
  final String location;
  final String? imageUrl;
  final String? contactNumber;
  final String? description;

  TempleModel({
    required this.id,
    required this.name,
    required this.samaj,
    required this.location,
    this.imageUrl,
    this.contactNumber,
    this.description,
  });

  factory TempleModel.fromMap(Map<String, dynamic> map) {
    return TempleModel(
      id: map['id'],
      name: map['name'],
      samaj: map['samaj'],
      location: map['location'],
      imageUrl: map['imageUrl'],
      contactNumber: map['contactNumber'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'samaj': samaj,
      'location': location,
      'imageUrl': imageUrl,
      'contactNumber': contactNumber,
      'description': description,
    };
  }
}
