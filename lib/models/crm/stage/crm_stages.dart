class CrmStages {
  int? id;
  String? name;
  bool? isWon;
  bool? isLost;

  CrmStages({this.id, this.name, this.isWon, this.isLost});

  CrmStages.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    isWon = json['is_won'] ?? false;
    isLost = json['is_lost'] ?? false;
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'is_won': isWon, 'is_lost': isLost};
  }

  CrmStages.defaultValue()
      : id = 1,
        name = 'COOL';
}
