class QuestionSurvey {
  final int id;
  final String title;

  QuestionSurvey({
    required this.id,
    required this.title,
  });

  factory QuestionSurvey.fromJson(Map<String, dynamic> json) {
    return QuestionSurvey(
      id: json["id"] ?? 0,
      title: json["title"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
    };
  }
}
