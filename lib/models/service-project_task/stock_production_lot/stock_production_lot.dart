class StockProductionLot {
  final int id;
  final String name;

  StockProductionLot({
    required this.id,
    required this.name,
  });

  factory StockProductionLot.fromJson(Map<String, dynamic> json) {
    return StockProductionLot(
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
