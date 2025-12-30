class OptionData {
  int id;
  String name;

  OptionData({required this.id, required this.name});

  factory OptionData.fromJson(Map<String, dynamic> json) {
    return OptionData(id: json['id'] ?? 0, name: json['name'] ?? "");
  }
}
