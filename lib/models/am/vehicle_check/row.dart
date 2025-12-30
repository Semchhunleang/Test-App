import 'question.dart';

class Rows {
  final int? id;
  final int? sequence;
  final bool? goodCheck;
  final bool? badCheck;
  final bool? nonCheck;
  final String? remark;
  final Question? question;

  Rows(
      {this.id,
      this.sequence,
      this.goodCheck,
      this.badCheck,
      this.nonCheck,
      this.remark,
      this.question});

  Rows.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? int,
        sequence = json['sequence'] ?? int,
        goodCheck = json['good_check'] ?? false,
        badCheck = json['bad_check'] ?? false,
        nonCheck = json['non_check'] ?? false,
        remark = json['remark'] ?? "",
        question = json['question'] != null
            ? Question.fromJson(json['question'])
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['sequence'] = sequence;
    data['good_check'] = goodCheck;
    data['bad_check'] = badCheck;
    data['non_check'] = nonCheck;
    data['remark'] = remark;
    if (question != null) {
      data['question'] = question!.toJson();
    }
    return data;
  }
}
