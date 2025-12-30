class ICTRequestCategory {
  int id;
  String name;

  ICTRequestCategory({
    required this.id,
    required this.name,
  });

  factory ICTRequestCategory.fromJson(Map<String, dynamic> json) {
    return ICTRequestCategory(
      id: json['id'],
      name: json['name'],
    );
  }
}
