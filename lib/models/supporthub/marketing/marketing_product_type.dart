class MarketingProductType {
  int id;
  String name;

  MarketingProductType({
    required this.id,
    required this.name,
  });

  factory MarketingProductType.fromJson(Map<String, dynamic> json) {
    return MarketingProductType(
      id: json['id'],
      name: json['name'],
    );
  }
}
