class FsAction {
  final int id;
  final String? name;

  FsAction({
    required this.id,
    this.name,
  });

  static FsAction fromJson(Map<String, dynamic>  json) {
    return FsAction(
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