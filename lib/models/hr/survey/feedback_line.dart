import 'package:umgkh_mobile/models/hr/survey/matrix_row.dart';
import 'package:umgkh_mobile/models/hr/survey/question.dart';
import 'package:umgkh_mobile/models/hr/survey/suggessted_answer.dart';

class FeedbackLine {
  final int? id;
  final int? sequence;
  final QuestionSurvey? question;
  final int? answerScore;
  final SuggestedAnswer? suggestedAnswer;
  final MatrixRow? matrixRow;

  FeedbackLine({
    this.id,
    this.sequence,
    this.question,
    this.answerScore,
    this.suggestedAnswer,
    this.matrixRow,
  });

  factory FeedbackLine.fromJson(Map<String, dynamic> json) {
    return FeedbackLine(
      id: json["id"],
      sequence: json["sequence"],
      question: json["question"] != null
          ? QuestionSurvey.fromJson(json["question"])
          : null,
      answerScore: json["answer_score"],
      suggestedAnswer: json["suggested_answer"] != null
          ? SuggestedAnswer.fromJson(json["suggested_answer"])
          : null,
      matrixRow: json["matrix_row"] != null
          ? MatrixRow.fromJson(json["matrix_row"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "sequence": sequence,
      "question": question?.toJson(),
      "answer_score": answerScore,
      "suggested_answer": suggestedAnswer?.toJson(),
      "matrix_row": matrixRow?.toJson(),
    };
  }
}
