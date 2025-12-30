import 'package:umgkh_mobile/models/e-catalog/website_category/website_category.dart';
import 'package:umgkh_mobile/models/service-project_task/product_category/product_category.dart';

class Product {
  final int id;
  final String name;
  final String? defaultCode;
  final String? textDesc;
  final String? parameter;
  final String? features;
  final int haveCatalog;
  final int haveMaintenanceSchedule;
  WebsiteCategory? category;
  ProductCategory? productCategory;

  Product({
    required this.id,
    required this.name,
    this.defaultCode,
    this.textDesc,
    this.parameter,
    this.features,
    required this.haveCatalog,
    this.category,
    this.productCategory,
    this.haveMaintenanceSchedule = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    WebsiteCategory? websiteCategory =
        json['category'] != null && json['category']['id'] != null
            ? WebsiteCategory.fromJson(json['category'])
            : null;
    ProductCategory? productCategory = json['product_category'] != null &&
            json['product_category']['id'] != null
        ? ProductCategory.fromJson(json['product_category'])
        : null;

    return Product(
        id: json['id'],
        name: json['name'],
        defaultCode: json['default_code'],
        textDesc: json['text_desc'] ?? '-',
        parameter: json['parameter'] ?? '-',
        features: json['features'] ?? '-',
        haveCatalog: json['have_catalog'],
        haveMaintenanceSchedule: json['have_maintenance_schedule'] as int? ?? 0,
        category: websiteCategory,
        productCategory: productCategory);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'default_code': defaultCode,
      'text_desc': textDesc,
      'parameter': parameter,
      'features': features,
      'have_catalog': haveCatalog,
      // 'category': category?.toJson(),
      // 'product_category': productCategory?.toJson()
    };
  }
}
