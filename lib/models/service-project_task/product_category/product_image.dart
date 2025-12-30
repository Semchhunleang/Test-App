class ProductImage {
  final int id;
  final int priority;

  ProductImage({
    required this.id,
    required this.priority,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      priority: json['priority'],
    );
  }
}
