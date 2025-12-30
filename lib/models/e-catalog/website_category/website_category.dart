class WebsiteCategory {
  final int id;
  final String name;
  final String completeName;
  final int? parentId;
  final String parentPath;
  final int? sequence;
  final int? countProduct;
  final int? totalCountProduct;
  final List<WebsiteCategory>? children;

  WebsiteCategory({
    required this.id,
    required this.name,
    required this.completeName,
    this.parentId,
    required this.parentPath,
    this.sequence,
    this.countProduct,
    this.totalCountProduct,
    this.children,
  });

  factory WebsiteCategory.fromJson(Map<String, dynamic> json) {
    return WebsiteCategory(
      id: json['id'],
      name: json['name'] as String,
      completeName: json['complete_name'] as String,
      parentId: json['parent_id'] as int?,
      parentPath: json['parent_path'] as String,
      sequence: json['sequence'] as int,
      countProduct: int.tryParse(json['count_product']?.toString() ?? '0') ?? 0,
      totalCountProduct:
          int.tryParse(json['total_count_product']?.toString() ?? '0') ?? 0,
      // totalCountProduct: json['total_count_product'] as int,
      children: (json['children'] as List<dynamic>?)
          ?.map((child) =>
              WebsiteCategory.fromJson(child as Map<String, dynamic>),)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'complete_name': completeName,
      'parent_id': parentId,
      'parent_path': parentPath,
      'sequence': sequence,
      'count_product': countProduct,
      'total_count_product': totalCountProduct,
      'children': children?.map((child) => child.toJson(),).toList(),
    };
  }
}
