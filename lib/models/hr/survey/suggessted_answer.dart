class SuggestedAnswer {
  final int id;
  final String value;
  final int answerScore;

  SuggestedAnswer({
    required this.id,
    required this.value,
    required this.answerScore,
  });

  factory SuggestedAnswer.fromJson(Map<String, dynamic> json) {
    return SuggestedAnswer(
      id: json["id"],
      value: json["value"],
      answerScore: json["answer_score"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "value": value,
      "answer_score": answerScore,
    };
  }
}
