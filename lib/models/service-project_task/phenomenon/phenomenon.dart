class Phenomenon {
  final int id;
  final String? name;

  Phenomenon({
    required this.id,
    this.name,
  });

  static Phenomenon fromJson(Map<String, dynamic>  json) {
    return Phenomenon(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}