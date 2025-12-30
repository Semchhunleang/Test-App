class ProductCategory {
  final int id;
  final String completeName;

  ProductCategory({
    required this.id,
    required this.completeName,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    String cname = json['complete_name']??json['name'];

    return ProductCategory(
      id: json['id'],
      completeName: cname,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'complete_name': completeName,
    };
  }
}
