class Question {
  final int? id;
  final String? name;
  // final String? section;
  // final int? sequence;

  Question({this.id, this.name});

  Question.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? null,
        name = json['name'] ?? null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
