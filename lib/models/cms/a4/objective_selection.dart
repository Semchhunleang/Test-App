class ObjectiveSelection {
  int? id;
  String? name;

  ObjectiveSelection({this.id, this.name});

  ObjectiveSelection.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
