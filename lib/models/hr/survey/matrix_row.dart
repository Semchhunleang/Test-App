class MatrixRow {
  final int id;
  final String value;
  final int answerScore;

  MatrixRow({
    required this.id,
    required this.value,
    required this.answerScore,
  });

  factory MatrixRow.fromJson(Map<String, dynamic> json) {
    return MatrixRow(
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
